#!/bin/bash

TARGET_URL=${1:-"http://localhost:3000"}

echo "📊 실시간 모니터링 시작..."
echo "Target: $TARGET_URL"
echo "Ctrl+C로 종료"
echo ""

while true; do
    STATS=$(curl -s "$TARGET_URL/api/queue-status" || echo '{"error":"connection_failed"}')
    
    if echo "$STATS" | jq . >/dev/null 2>&1; then
        ACTIVE=$(echo $STATS | jq -r '.activeUsers // "N/A"')
        QUEUE=$(echo $STATS | jq -r '.queueLength // "N/A"')
        TOTAL=$(echo $STATS | jq -r '.totalRequests // "N/A"')
        SUCCESS_RATE=$(echo $STATS | jq -r '.successRate // "N/A"')
        STATUS=$(echo $STATS | jq -r '.systemStatus // "unknown"')
        
        echo "[$(date '+%H:%M:%S')] 상태: $STATUS | 활성: $ACTIVE | 대기: $QUEUE | 총요청: $TOTAL | 성공률: $SUCCESS_RATE"
    else
        echo "[$(date '+%H:%M:%S')] ❌ 연결 실패"
    fi
    
    sleep 3
done