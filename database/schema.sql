-- PostgreSQL + TimescaleDB Schema for Kalshi Trading Bot
-- Initialize TimescaleDB extension
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;

-- Markets table
CREATE TABLE IF NOT EXISTS markets (
    ticker VARCHAR(50) PRIMARY KEY,
    title TEXT NOT NULL,
    category VARCHAR(50),
    description TEXT,
    close_time TIMESTAMPTZ NOT NULL,
    status VARCHAR(20),
    yes_price_implied DECIMAL(5,4),
    no_price_implied DECIMAL(5,4),
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_markets_status ON markets(status);
CREATE INDEX idx_markets_close_time ON markets(close_time);
CREATE INDEX idx_markets_category ON markets(category);

-- Market snapshots (time-series data)
CREATE TABLE IF NOT EXISTS market_snapshots (
    id BIGSERIAL,
    market_ticker VARCHAR(50) NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL,
    yes_bid DECIMAL(4,3),
    yes_ask DECIMAL(4,3),
    no_bid DECIMAL(4,3),
    no_ask DECIMAL(4,3),
    volume_24h BIGINT,
    open_interest BIGINT,
    metadata JSONB,
    PRIMARY KEY (id, timestamp)
);

SELECT create_hypertable('market_snapshots', 'timestamp', if_not_exists => TRUE);
CREATE INDEX idx_market_snapshots_ticker ON market_snapshots(market_ticker, timestamp DESC);

-- Probability estimates (audit trail)
CREATE TABLE IF NOT EXISTS probability_estimates (
    id BIGSERIAL PRIMARY KEY,
    market_ticker VARCHAR(50) NOT NULL REFERENCES markets(ticker),
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    fair_value DECIMAL(5,4),
    confidence DECIMAL(3,2),
    model_reasoning JSONB,
    market_price_at_time DECIMAL(5,4),
    edge DECIMAL(5,4),
    gpt_estimate DECIMAL(5,4),
    claude_estimate DECIMAL(5,4)
);

CREATE INDEX idx_prob_estimates_market ON probability_estimates(market_ticker, timestamp DESC);
SELECT create_hypertable('probability_estimates', 'timestamp', if_not_exists => TRUE);

-- Positions table
CREATE TABLE IF NOT EXISTS positions (
    id BIGSERIAL PRIMARY KEY,
    market_ticker VARCHAR(50) NOT NULL REFERENCES markets(ticker),
    side VARCHAR(5) NOT NULL CHECK (side IN ('YES', 'NO')),
    contracts BIGINT NOT NULL,
    entry_price DECIMAL(5,4) NOT NULL,
    entry_fair_value DECIMAL(5,4),
    cost_basis DECIMAL(12,2) NOT NULL,
    opened_at TIMESTAMPTZ DEFAULT NOW(),
    closed_at TIMESTAMPTZ,
    exit_price DECIMAL(5,4),
    pnl DECIMAL(12,2),
    pnl_percent DECIMAL(6,4),
    exit_reason VARCHAR(50),
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'closed', 'cancelled')),
    metadata JSONB
);

CREATE INDEX idx_positions_status ON positions(status);
CREATE INDEX idx_positions_market ON positions(market_ticker);
CREATE INDEX idx_positions_opened_at ON positions(opened_at DESC);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    id BIGSERIAL PRIMARY KEY,
    client_order_id UUID UNIQUE NOT NULL,
    kalshi_order_id VARCHAR(100),
    market_ticker VARCHAR(50) NOT NULL REFERENCES markets(ticker),
    side VARCHAR(5) NOT NULL CHECK (side IN ('YES', 'NO')),
    order_type VARCHAR(20) NOT NULL CHECK (order_type IN ('limit', 'market')),
    limit_price DECIMAL(5,4),
    contracts BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'filled', 'cancelled', 'expired')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    filled_at TIMESTAMPTZ,
    fill_price DECIMAL(5,4),
    metadata JSONB
);

CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_market ON orders(market_ticker);
CREATE INDEX idx_orders_kalshi_id ON orders(kalshi_order_id);

-- Daily performance metrics (rollup)
CREATE TABLE IF NOT EXISTS daily_performance (
    date DATE PRIMARY KEY,
    starting_bankroll DECIMAL(12,2),
    ending_bankroll DECIMAL(12,2),
    pnl DECIMAL(12,2),
    pnl_pct DECIMAL(6,4),
    trades_opened INTEGER,
    trades_closed INTEGER,
    closed_profitable INTEGER,
    closed_losing INTEGER,
    win_rate DECIMAL(4,3),
    avg_win DECIMAL(12,2),
    avg_loss DECIMAL(12,2),
    max_drawdown DECIMAL(6,4),
    sharpe_ratio DECIMAL(5,3),
    max_open_risk DECIMAL(12,2),
    avg_hold_time_minutes INTEGER,
    metadata JSONB
);

-- Portfolio state (current)
CREATE TABLE IF NOT EXISTS portfolio_state (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    current_bankroll DECIMAL(12,2),
    peak_bankroll DECIMAL(12,2),
    open_risk DECIMAL(12,2),
    max_allowed_risk DECIMAL(12,2),
    daily_pnl DECIMAL(12,2),
    open_positions_count INTEGER,
    trading_paused BOOLEAN DEFAULT FALSE,
    metadata JSONB
);

CREATE INDEX idx_portfolio_timestamp ON portfolio_state(timestamp DESC);

-- Risk events log
CREATE TABLE IF NOT EXISTS risk_events (
    id BIGSERIAL PRIMARY KEY,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    event_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) CHECK (severity IN ('info', 'warning', 'critical')),
    message TEXT,
    metadata JSONB
);

CREATE INDEX idx_risk_events_type ON risk_events(event_type);
CREATE INDEX idx_risk_events_timestamp ON risk_events(timestamp DESC);

-- Grant permissions to bot user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO kalshi_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO kalshi_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO kalshi_user;
