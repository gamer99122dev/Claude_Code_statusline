# Claude Code Statusline（Windows）

超簡潔的狀態列，顯示目前模型、5 小時剩餘用量、每週剩餘用量：

```
Sonnet 5.5 │ 5h 32% │ Week 18%
```

數字是**剩餘** %（= 100 − 已用）。

## 需求

- Windows + PowerShell（Windows 內建的即可）
- Claude Code，且用 **Claude.ai 訂閱（Pro / Max）** 登入
  - 用 API key 登入時沒有用量資料，只會顯示模型名稱
  - 每個 session 要等第一次 API 回應後，才會出現 5h / Week 數字

## 安裝（一鍵）

在這個資料夾打開 PowerShell，執行：

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

它會把 `statusline.ps1` 複製到 `~\.claude\`，並把 `statusLine` 合併進 `~\.claude\settings.json`（其他設定保留；原本的 `settings.json` 會先備份成 `settings.json.bak`）。完成後重開 Claude Code。

重複執行是安全的。

## 安裝（手動）

1. 把 `statusline.ps1` 複製到 `C:\Users\<你的使用者名稱>\.claude\statusline.ps1`
2. 打開 `C:\Users\<你的使用者名稱>\.claude\settings.json`，加入 `statusLine`
   （檔案已有其他設定的話，只要加這一段，注意前一行結尾要有逗號）：

   ```json
   "statusLine": {
     "type": "command",
     "command": "powershell -NoProfile -ExecutionPolicy Bypass -File C:/Users/<你的使用者名稱>/.claude/statusline.ps1"
   }
   ```

   路徑請用正斜線 `/`，並把 `<你的使用者名稱>` 換成自己的。
3. 重開 Claude Code（或開新 session）。

## 測試

不用開 Claude Code，直接餵假資料：

```powershell
'{"model":{"display_name":"Sonnet 5.5"},"rate_limits":{"five_hour":{"used_percentage":68.2},"seven_day":{"used_percentage":82.4}}}' | powershell -NoProfile -ExecutionPolicy Bypass -File .\statusline.ps1
```

應該印出 `Sonnet 5.5 │ 5h 32% │ Week 18%`。

## 改成顯示「已用」

把 `statusline.ps1` 裡的 `100 - $r.five_hour.used_percentage` 改成 `$r.five_hour.used_percentage`，`seven_day` 同理。

## 原理

Claude Code 每次更新狀態列時，會把 JSON 從 stdin 傳給 `statusLine.command`，腳本印出什麼就顯示什麼。用到的欄位：`model.display_name`、`rate_limits.five_hour.used_percentage`、`rate_limits.seven_day.used_percentage`。
