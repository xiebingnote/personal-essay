package common

import (
	"bytes"
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"time"

	log "github.com/sirupsen/logrus"
)

const (
	DingKeyWord     = "关键词"
	DingSecret      = "SECxxxxxxxxxxxxxx"
	DingAccessToken = "xxxxxxxxxxxxxxxxx"
)

type DingRequest struct {
	timestamp   int64
	secret      string
	sign        string
	content     string
	accessToken string
}

func NewDingRequest(secret, accessToken string, timestamp int64, content string) *DingRequest {
	if timestamp == 0 {
		timestamp = time.Now().UnixMilli()
	}
	return &DingRequest{timestamp: timestamp, secret: secret, content: content, accessToken: accessToken}
}

func (r *DingRequest) genSign() string {
	stringToSign := fmt.Sprintf("%d\n%s", r.timestamp, r.secret)

	mac := hmac.New(sha256.New, []byte(r.secret))
	_, err := mac.Write([]byte(stringToSign))
	if err != nil {
		log.Error("Error generating sign", "error", err)
		return ""
	}
	return url.QueryEscape(base64.StdEncoding.EncodeToString(mac.Sum(nil)))
}

func (r *DingRequest) buildDingURL() string {
	return fmt.Sprintf(
		"https://oapi.dingtalk.com/robot/send?access_token=%s&timestamp=%d&sign=%s",
		r.accessToken,
		r.timestamp,
		r.genSign(),
	)
}

func (r *DingRequest) Send(ctx context.Context) error {
	urlRobot := r.buildDingURL()
	jsonBody := fmt.Sprintf(`{"msgtype":"text","text":{"content":"%s"}}`, r.content)
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, urlRobot, bytes.NewBuffer([]byte(jsonBody)))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json;charset=utf-8")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)
	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("dingding API error: %s", string(body))
	}
	return nil
}
