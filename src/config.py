"""Configuration management for Kalshi trading bot"""

import os
from typing import Optional
from dataclasses import dataclass
from dotenv import load_dotenv

load_dotenv()


@dataclass
class KalshiConfig:
    """Kalshi API configuration"""
    api_key: str = os.getenv('KALSHI_API_KEY', '')
    api_secret: str = os.getenv('KALSHI_API_SECRET', '')
    sandbox: bool = os.getenv('KALSHI_SANDBOX', 'false').lower() == 'true'
    base_url: str = 'https://api-sandbox.kalshi.com' if sandbox else 'https://trading-api.kalshi.com'
    ws_url: str = 'wss://trading-api-sandbox.kalshi.com/trade-api/ws/v2' if sandbox else 'wss://trading-api.kalshi.com/trade-api/ws/v2'


@dataclass
class AIConfig:
    """AI model configuration"""
    openai_key: str = os.getenv('OPENAI_API_KEY', '')
    anthropic_key: str = os.getenv('ANTHROPIC_API_KEY', '')  # Optional
    
    # If Anthropic key not provided, use OpenAI only
    ensemble_enabled: bool = (
        os.getenv('PROBABILITY_MODEL_ENSEMBLE', 'auto').lower() == 'true' or
        (os.getenv('PROBABILITY_MODEL_ENSEMBLE', 'auto').lower() == 'auto' and 
         os.getenv('ANTHROPIC_API_KEY', '') != '')
    )
    
    gpt_weight: float = 1.0 if not ensemble_enabled else float(os.getenv('GPT_MODEL_WEIGHT', '0.55'))
    claude_weight: float = 0.0 if not ensemble_enabled else float(os.getenv('CLAUDE_MODEL_WEIGHT', '0.45'))
    temperature: float = float(os.getenv('MODEL_TEMPERATURE', '0.3'))
    max_tokens: int = int(os.getenv('MODEL_MAX_TOKENS', '1000'))


@dataclass
class DatabaseConfig:
    """Database configuration"""
    url: str = os.getenv('DATABASE_URL', 'postgresql://kalshi_user:kalshi_password@postgres:5432/kalshi_db')
    redis_url: str = os.getenv('REDIS_URL', 'redis://redis:6379/0')
    pool_size: int = 10
    max_overflow: int = 20
    pool_timeout: int = 30
    pool_recycle: int = 3600


@dataclass
class TradingConfig:
    """Trading parameters"""
    initial_bankroll: float = float(os.getenv('INITIAL_BANKROLL', '50.0'))
    max_risk_per_trade: float = float(os.getenv('MAX_RISK_PER_TRADE', '1.0'))
    max_total_risk: float = float(os.getenv('MAX_TOTAL_RISK', '10.0'))
    max_correlated_risk: float = float(os.getenv('MAX_CORRELATED_RISK', '6.0'))
    max_daily_loss: float = float(os.getenv('MAX_DAILY_LOSS', '5.0'))
    fractional_kelly: float = float(os.getenv('FRACTIONAL_KELLY', '0.25'))
    min_edge: float = float(os.getenv('MIN_EDGE', '0.05'))
    max_positions: int = int(os.getenv('MAX_POSITIONS', '10'))
    drawdown_circuit_breaker: float = float(os.getenv('DRAWDOWN_CIRCUIT_BREAKER', '0.20'))
    live_trading: bool = os.getenv('LIVE_TRADING', 'false').lower() == 'true'
    auto_deposit_profits: bool = os.getenv('AUTO_DEPOSIT_PROFITS', 'false').lower() == 'true'


@dataclass
class MarketScanConfig:
    """Market scanning configuration"""
    scan_interval: int = int(os.getenv('SCAN_INTERVAL', '300'))
    min_days_to_close: int = int(os.getenv('MARKET_AGE_FILTER_MIN_DAYS', '1'))
    max_days_to_close: int = int(os.getenv('MARKET_AGE_FILTER_MAX_DAYS', '30'))
    min_volume_24h: float = float(os.getenv('MIN_MARKET_VOLUME_24H', '50'))
    correlation_threshold: float = float(os.getenv('CORRELATION_THRESHOLD', '0.70'))


@dataclass
class MonitoringConfig:
    """Monitoring and alerting configuration"""
    discord_webhook_url: Optional[str] = os.getenv('DISCORD_WEBHOOK_URL')
    prometheus_port: int = int(os.getenv('PROMETHEUS_PORT', '8000'))
    log_level: str = os.getenv('LOG_LEVEL', 'INFO')
    log_file: str = os.getenv('LOG_FILE', '/app/logs/trading_bot.log')
    log_to_stdout: bool = os.getenv('LOG_TO_STDOUT', 'true').lower() == 'true'
    log_max_size_mb: int = int(os.getenv('LOG_MAX_SIZE_MB', '100'))
    log_backup_count: int = int(os.getenv('LOG_BACKUP_COUNT', '5'))


class Config:
    """Master configuration class"""
    
    kalshi = KalshiConfig()
    ai = AIConfig()
    database = DatabaseConfig()
    trading = TradingConfig()
    market_scan = MarketScanConfig()
    monitoring = MonitoringConfig()
    
    @classmethod
    def validate(cls) -> bool:
        """Validate all configuration values"""
        errors = []
        warnings = []
        
        # Check required API keys
        if not cls.kalshi.api_key:
            errors.append('KALSHI_API_KEY not set')
        if not cls.kalshi.api_secret:
            errors.append('KALSHI_API_SECRET not set')
        if not cls.ai.openai_key:
            errors.append('OPENAI_API_KEY not set (required)')
        
        # Check optional keys
        if not cls.ai.anthropic_key:
            warnings.append('ANTHROPIC_API_KEY not set - using OpenAI only (ensemble disabled)')
        
        # Check trading parameters
        if cls.trading.max_risk_per_trade <= 0:
            errors.append('MAX_RISK_PER_TRADE must be positive')
        if cls.trading.max_total_risk < cls.trading.max_risk_per_trade:
            errors.append('MAX_TOTAL_RISK must be >= MAX_RISK_PER_TRADE')
        if cls.trading.initial_bankroll < 10:
            errors.append('INITIAL_BANKROLL must be at least $10')
        
        # Display warnings
        if warnings:
            print('\n⚠️  Configuration warnings:')
            for warning in warnings:
                print(f'  - {warning}')
        
        # Display errors
        if errors:
            print('\n❌ Configuration errors:')
            for error in errors:
                print(f'  - {error}')
            return False
        
        # Display AI mode
        if cls.ai.ensemble_enabled:
            print('\n🤖 AI Mode: Ensemble (GPT-4 + Claude)')
        else:
            print('\n🤖 AI Mode: OpenAI Only (GPT-4)')
        
        return True


if __name__ == '__main__':
    # Test configuration
    if Config.validate():
        print('\n✅ Configuration is valid')
    else:
        print('\n❌ Configuration has errors')
