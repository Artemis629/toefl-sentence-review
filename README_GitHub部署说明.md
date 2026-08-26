# TOEFL 句子错题网站：GitHub Pages + 多端同步

这个部署包已经包含：

- `index.html`：244 道句子错题网站；
- `supabase_schema.sql`：云端进度表和隐私权限；
- `TOEFL_Grammar_Weakness_Guide.pdf`：网页 G01–G11 对应的语法学习手册；
- 本说明文件。

网站每天默认开放 10 道新题。完成当前一组后，可以点“再加一组（10题）”，做完后仍可继续增加。已经到期的复习题会自动加入队列，不受新题组数限制。

## 第一部分：先发布到 GitHub Pages

### 第 1 步：创建仓库

1. 登录 GitHub。
2. 右上角点 `+` → `New repository`。
3. Repository name 填：`toefl-sentence-review`。
4. 选择 `Public`。
5. 点击 `Create repository`。

GitHub Free 使用 GitHub Pages 时，最省事的是公开仓库。不要在仓库里放身份证、密码、银行卡等隐私资料；本项目只有英语题库和网页程序。

### 第 2 步：上传文件

1. 在新仓库页面点 `Add file` → `Upload files`。
2. 上传本文件夹里的：
   - `index.html`
   - `supabase_schema.sql`
   - `TOEFL_Grammar_Weakness_Guide.pdf`
   - `README_GitHub部署说明.md`
3. 点 `Commit changes`。

### 第 3 步：开启 GitHub Pages

1. 仓库顶部进入 `Settings`。
2. 左侧进入 `Pages`。
3. `Build and deployment` 中：
   - Source 选 `Deploy from a branch`；
   - Branch 选 `main`；
   - Folder 选 `/ (root)`；
   - 点 `Save`。
4. 等待约 1–5 分钟，刷新 Pages 页面。

网站地址通常是：

`https://你的GitHub用户名.github.io/toefl-sentence-review/`

先保存这个完整地址，后面设置邮箱登录回跳时要使用。

GitHub 官方说明：<https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site>

## 第二部分：建立 Supabase 云端进度库

### 第 4 步：创建 Supabase 项目

1. 打开 <https://supabase.com/dashboard> 并注册/登录。
2. 点击 `New project`。
3. 设置项目名称和数据库密码，区域选择离你较近的区域。
4. 等待项目创建完成。

### 第 5 步：建立进度表与个人权限

1. Supabase 左侧打开 `SQL Editor`。
2. 回到 GitHub 仓库，打开 `supabase_schema.sql`。
3. 复制全部内容，粘贴到 SQL Editor。
4. 点击 `Run`。

这段 SQL 会开启 Row Level Security：每个登录用户只能读取和修改自己的那一行学习进度。

Supabase 官方 RLS 说明：<https://supabase.com/docs/guides/database/postgres/row-level-security>

### 第 6 步：复制两个公开配置值

1. 在 Supabase 项目中点击右上或页面里的 `Connect`。
2. 找到并复制：
   - `Project URL`；
   - `Publishable key`（通常以 `sb_publishable_` 开头）。

只能复制 **Publishable key**。绝对不要把 `Secret key` 或旧版 `service_role` 密钥放进网页。

Supabase 官方说明：浏览器端使用 Project URL + Publishable key，并依靠 RLS 保护每个用户的数据。

### 第 7 步：把配置填入网页

1. 回到 GitHub 仓库，打开 `index.html`。
2. 点击右上角铅笔图标编辑。
3. 按 `Ctrl + F` 搜索：`YOUR_SUPABASE_PROJECT_URL`。
4. 把它替换为你的 Project URL，例如：

   `https://abcdefg.supabase.co`

5. 把 `YOUR_SUPABASE_PUBLISHABLE_KEY` 替换为你的 Publishable key。
6. 点击 `Commit changes`。
7. 等待 GitHub Pages 自动重新发布。

### 第 8 步：设置邮箱登录后的返回地址

1. Supabase 左侧进入 `Authentication`。
2. 进入 `URL Configuration`。
3. `Site URL` 填你的完整 GitHub Pages 地址，例如：

   `https://用户名.github.io/toefl-sentence-review/`

4. 在 `Redirect URLs` 中也添加同一个完整地址。
5. 保存。

生产网站建议填写精确地址，不要使用过宽的通配符。官方说明：<https://supabase.com/docs/guides/auth/redirect-urls>

## 第三部分：第一次登录与旧进度迁移

### 如果以前已经在本地网页做过题

1. 打开这次更新后的本地 HTML 文件。
2. 点击顶部 `导出进度`，会下载一个 JSON 文件。
3. 打开 GitHub Pages 网站。
4. 点击 `导入进度`，选择刚才的 JSON。
5. 确认网页显示“导入成功”。
6. 再输入邮箱并点击 `发送登录链接`。

### 登录

1. 输入你固定使用的邮箱。
2. 点击 `发送登录链接`。
3. 去邮箱点击 Supabase 发来的链接。
4. 页面回到网站并显示 `已同步 · 你的邮箱`。

在手机、平板或另一台电脑上，打开同一个 GitHub Pages 地址，用同一个邮箱登录，即可取得相同进度。

## 第四部分：检查是否成功

建议做一次完整测试：

1. 电脑端登录后做 1 道题。
2. 点击 `立即同步`，确认顶部显示“已同步”。
3. 手机端打开网站，用同一邮箱登录。
4. 在“全部题目”查看这道题的状态是否一致。
5. 手机端再做 1 道，回电脑点“立即同步”检查。

## 日常使用逻辑

- 每天自动开放第一组 10 道新题。
- 所有已到复习时间的题优先进入队列。
- 完成本组后点“再加一组（10题）”。
- 可以反复追加，没有人为设置每日上限。
- 错题仍按 5 分钟后重测；正确题按 6小时 → 1天 → 2天 → 4天 → 8天 → 16天复习。
- 同一题反复答错时仍显示 G01–G11 语法编号。

## 常见问题

### 网页显示“本地模式”

通常是 `index.html` 里两个 Supabase 配置值还没替换，或 GitHub Pages 还没重新发布。

### 收到邮件，点击后没有回到网页

检查 Supabase `Authentication → URL Configuration`，Site URL 和 Redirect URL 必须包含完整的 `https://`、仓库名和末尾 `/`。

### 换设备没有看到进度

确认两台设备使用同一邮箱，并分别显示“已同步”。然后点一次“立即同步”。

### 旧本地进度没有自动出现

本地文件和 GitHub 网站是两个不同地址，必须先在本地版“导出进度”，再在网站版“导入进度”。只需迁移一次。
