# 🎲 ROLL FOR ANIME! (LĂN CHO ANIME! 🎲) - ULTIMATE AUTO HUB V2.0 (TURBO FAST ROLL)

Script hỗ trợ tự động chơi và tối ưu may mắn toàn diện cho tựa game **Roll for Anime! 🎲** (tên hiển thị tiếng Việt: **Lăn cho Anime! 🎲**) trên Roblox, được phát triển bởi nhóm **Proton Laboratory**.

Tương thích mượt mà 100% cho **Delta Executor (Android & PC)**, Codex, Wave, Hydrogen, Fluxus và Solara.

---

## 🚀 Cách Sử Dụng (Script Execution Command)

Chỉ cần sao chép lệnh bên dưới và dán vào Executor của bạn (Delta / Codex / Wave / Fluxus):

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/khahuynh963/roll_anime/main/loader.lua"))()
```

Hoặc chạy trực tiếp file script chính:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/khahuynh963/roll_anime/main/script.lua"))()
```

---

## ⚡ CẬP NHẬT MỚI V2.0 - ĐỘT PHÁ TURBO FAST ROLL

Nếu trước đây bạn thấy game vẫn roll chậm (mất 3-5 giây mỗi lượt), nguyên nhân là do **Animation lăn xúc xắc và Cutscene** của game khóa nút bấm. Bản **V2.0** đã khắc phục hoàn toàn:

1. **🎯 Tự Động Bắt Remote Roll (Hook Metamethod __namecall)**:
   * Tự động bắt chính xác 100% Remote và tham số mà game sử dụng khi roll.
   * Gọi trực tiếp Server Remote ở tốc độ cao nhất, **bỏ qua hoàn toàn giao diện và thời gian chờ (cooldown)** của nút bấm.
2. **🔥 Hủy Bỏ Hoạt Ảnh & Cutscene (Neutralize Animations)**:
   * Chạy trên `RenderStepped` để tự động ẩn các khung hoạt ảnh xúc xắc, tắt animation của nhân vật và mở khóa Camera ngay lập tức.
   * Tự động bấm nút "Skip / Fast Roll" có sẵn trong cài đặt game.
3. **⏱️ Bộ Điều Chỉnh Tốc Độ Roll (Speed Presets)**:
   * ⚡ **Chớp Nhoáng (0.03s)**: Tốc độ tối đa không độ trễ.
   * 🚀 **Siêu Tốc (0.05s)**: Tối ưu cho treo máy mượt mà.
   * 🔥 **Cực Nhanh (0.10s)**: Dành cho máy yếu hoặc mạng lag.
   * ⏱️ **Bình Thường (0.25s) / An Toàn (0.50s)**.
4. **📡 Bảng Hiển Thị Thông Tin Remote**:
   * Hiển thị trực tiếp tên Remote mà script đã bắt được lên menu để bạn dễ dàng theo dõi.
   * Nút **"🎯 NHẤN THỬ 1 LẦN"** giúp bạn kích hoạt bắt Remote ngay từ lần nhấn đầu tiên.

---

## ✨ Các Tính Năng Cốt Lõi Khác

### 🍀 1. Tối Đa Hóa May Mắn (Luck Boosters)
* **🎲 Auto Upgrade Dice**: Tự động dùng tiền vàng nâng cấp cấp bậc xúc xắc lên các cấp cao hơn để kích hoạt hệ số nhân may mắn chính thức của game (như x2, x5, x67 Luck...).
* **🧪 Auto Use Luck Potions**: Tự động uống các bình thuốc may mắn (Luck Potions) trong kho đồ khi buff cũ hết hiệu lực.
* **🍀 Auto Use Lucky Clovers**: Tự động sử dụng cỏ 4 lá may mắn để đẩy tỷ lệ ra Anime cấp cao lên cực đại.
* **🧲 Auto Collect Map Drops**: Tự động hút cỏ 4 lá may mắn, tiền xu, kim cương và phần thưởng rơi rải rác trên bản đồ.
* **🔄 Auto Rebirth**: Tự động chuyển sinh nhận bội số nhân may mắn và gia tăng tốc độ cày tiền.

### ⚔️ 2. Quản Lý Anime & Tự Động Dọn Túi Đồ
* **👑 Auto Equip Best Anime**: Tự động trang bị các Anime mạnh nhất trong kho để nhân tối đa tốc độ kiếm $/s.
* **🏰 Auto Place Anime**: Tự động xếp các nhân vật Anime lên bệ/ô kiếm tiền tự động.
* **🗑️ Auto Delete / Skip Low Rarity**: Tự động vứt/bán các Anime phẩm cấp thấp (Common, Uncommon, Rare) để ngăn chặn tình trạng đầy túi đồ làm gián đoạn quá trình lăn.
* **🎁 One-Click Redeem All Codes**: Tự động nhập toàn bộ mã giftcode mới nhất (`CRIMSON`, `TITAN`, `ILOVEYALL`, `ThanksForSupport!`, `RELEASE`...) nhận quà tặng, bình thuốc may mắn và lượt roll miễn phí.

### 🏃 3. Tốc Độ & Vật Lý Gian Lận (Movement)
* **⚡ WalkSpeed Customizer**: Tùy chỉnh tốc độ di chuyển từ 32 đến 350 với Stepped Loop chống reset tốc độ.
* **🌀 Lướt CFrame Siêu Âm**: Tăng tốc lướt CFrame (2x, 5x, 10x, 20x, 40x) cực mượt mà không bị giật lag hay rubberband.
* **🦘 Infinite Jump**: Nhảy vô hạn trên không trung.
* **👻 Noclip**: Đi xuyên tường và mọi chướng ngại vật trên bản đồ.
* **🛸 Float / Hover**: Khóa độ cao trục Y giúp nhân vật bay lơ lửng trên không trung.

### 🛡️ 4. Hỗ Trợ Treo Máy 24/7 & Tối Ưu Hiệu Năng
* **🛡️ Anti-AFK 24/7**: Chống bị văng game (Kick for idle 20 minutes) giúp bạn yên tâm treo máy cày Anime xuyên đêm.
* **🚀 FPS Booster / Low Graphics**: Tắt bóng đổ, khử hiệu ứng hạt nặng hạt để máy chạy mát, tiết kiệm pin khi treo nhiều tài khoản trên điện thoại hoặc giả lập PC.

---

## 🎨 Giao Diện Cyberpunk Tối Ưu Màn Hình
* Tông màu chủ đạo **Crimson Red & Deep Anime Purple** thời thượng.
* Khung điều khiển có thể kéo thả tự do trên màn hình (Draggable).
* Tích hợp **Nút Tròn Thu Nhỏ (Floating Icon Toggle ⚡)** giúp bạn ẩn/hiện bảng điều khiển nhanh chóng khi đang chơi trên điện thoại (Delta Executor).

---

## 🌐 Thông Tin Repository
* **GitHub Repository**: `https://github.com/khahuynh963/roll_anime.git`
* **Tác giả**: `khahuynh963`
