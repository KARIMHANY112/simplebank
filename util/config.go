package util

import (
    "bufio"
    "errors"
    "fmt"
    "os"
    "path/filepath"
    "strings"
    "time"
)

// Config stores all configuration values for the application.
type Config struct {
    DBSource             string        `mapstructure:"DB_SOURCE"`
    TokenSymmetricKey    string        `mapstructure:"TOKEN_SYMMETRIC_KEY"`
    AccessTokenDuration  time.Duration `mapstructure:"ACCESS_TOKEN_DURATION"`
    RefreshTokenDuration time.Duration `mapstructure:"REFRESH_TOKEN_DURATION"`
}

// LoadConfig reads configuration from a .env-style file and environment variables.
// It looks for an app.env file in the provided path and loads values from it.
func LoadConfig(path string) (config Config, err error) {
    envFile := filepath.Join(path, "app.env")
    if _, statErr := os.Stat(envFile); statErr == nil {
        if err = loadEnvFile(envFile); err != nil {
            return config, err
        }
    }

    config.DBSource = os.Getenv("DB_SOURCE")
    if config.DBSource == "" {
        return config, errors.New("DB_SOURCE is not set")
    }

    config.TokenSymmetricKey = os.Getenv("TOKEN_SYMMETRIC_KEY")
    if config.TokenSymmetricKey == "" {
        return config, errors.New("TOKEN_SYMMETRIC_KEY is not set")
    }

    config.AccessTokenDuration, err = time.ParseDuration(os.Getenv("ACCESS_TOKEN_DURATION"))
    if err != nil {
        return config, fmt.Errorf("invalid ACCESS_TOKEN_DURATION: %w", err)
    }

    config.RefreshTokenDuration, err = time.ParseDuration(os.Getenv("REFRESH_TOKEN_DURATION"))
    if err != nil {
        return config, fmt.Errorf("invalid REFRESH_TOKEN_DURATION: %w", err)
    }

    return config, nil
}

func loadEnvFile(path string) error {
    file, err := os.Open(path)
    if err != nil {
        return err
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := strings.TrimSpace(scanner.Text())
        if line == "" || strings.HasPrefix(line, "#") {
            continue
        }

        parts := strings.SplitN(line, "=", 2)
        if len(parts) != 2 {
            continue
        }

        key := strings.TrimSpace(parts[0])
        val := strings.TrimSpace(parts[1])
        if key == "" {
            continue
        }

        if _, exists := os.LookupEnv(key); !exists {
            os.Setenv(key, strings.Trim(val, `"`))
        }
    }

    return scanner.Err()
}
