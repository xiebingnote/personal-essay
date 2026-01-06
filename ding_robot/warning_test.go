package common

import (
	"context"
	"fmt"
	"testing"
	"time"
)

func TestQuery(t *testing.T) {
	ctx := context.Background()
	tt := time.Now().UnixMilli()
	msg := fmt.Sprintf("%s:%s", DingKeyWord, "测试")
	err := NewDingRequest(DingSecret, DingAccessToken, tt, msg).Send(ctx)
	if err != nil {
		t.Error(err)
	}
}
