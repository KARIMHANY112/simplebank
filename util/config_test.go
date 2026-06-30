package util

import (
	"testing"

	"github.com/spf13/viper"
	"github.com/stretchr/testify/require"
)

func TestLoadConfigUsesDefaultDBSource(t *testing.T) {
	viper.Reset()
	t.Setenv("DB_SOURCE", "")

	config, err := LoadConfig("..")
	require.NoError(t, err)
	require.Equal(t, defaultDBSource, config.DBSource)
}
