<?php
$unlock_data = [
    ["country" => "USA", "carrier" => "Sprint", "code" => "XXXX-1234", "link" => "https://adsterra-link.com/sprint"],
    ["country" => "UK", "carrier" => "Vodafone", "code" => "VF-2025-UNL", "link" => "https://adsterra-link.com/vodafone"],
    ["country" => "Canada", "carrier" => "Bell", "code" => "BELL-321", "link" => "https://adsterra-link.com/bell"],
    ["country" => "Australia", "carrier" => "Telstra", "code" => "TEL-5555", "link" => "https://adsterra-link.com/telstra"]
];
function safe_redirect($url) {
    $domain = parse_url($url, PHP_URL_HOST);
    $allowed = ['adsterra-link.com'];
    if (in_array($domain, $allowed)) {
        echo "<meta http-equiv='refresh' content='2;url=$url'>";
    } else {
        echo "<p>Invalid link.</p>";
    }
    exit;
}
if (isset($_GET['redirect'])) {
    safe_redirect($_GET['redirect']);
}
?><!DOCTYPE html><html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SIM Unlock Portal | nirobtech.com</title>
  <meta name="description" content="Unlock SIMs globally. Ad-supported free tools for USA, UK, Canada, Australia. Reliable, mobile-friendly, and secure.">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary: #1D4ED8;
      --secondary: #1E40AF;
      --bg: #F9FAFB;
      --white: #ffffff;
      --gray: #6B7280;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Inter', sans-serif; background-color: var(--bg); color: var(--gray); line-height: 1.6; }
    .container { max-width: 1140px; margin: 0 auto; padding: 20px; background: var(--white); border-radius: 12px; box-shadow: 0 0 25px rgba(0,0,0,0.05); }
    header { text-align: center; padding-bottom: 20px; }
    header h1 { font-size: 2rem; color: var(--primary); margin-bottom: 10px; }
    header p { font-size: 1.1rem; }
    table { width: 100%; border-collapse: collapse; margin: 30px 0; }
    th, td { padding: 14px 12px; text-align: left; border-bottom: 1px solid #e5e7eb; }
    th { background-color: var(--primary); color: white; text-transform: uppercase; font-size: 0.9rem; }
    tr:hover { background-color: #EFF6FF; }
    .btn { display: inline-block; background-color: var(--primary); color: white; padding: 10px 20px; border-radius: 8px; font-weight: 600; text-decoration: none; transition: background 0.3s ease; }
    .btn:hover { background-color: var(--secondary); }
    .guide { background-color: #F3F4F6; padding: 20px; border-radius: 10px; margin-top: 30px; }
    .guide h2 { color: var(--primary); margin-bottom: 10px; }
    footer { text-align: center; margin-top: 30px; font-size: 0.9rem; color: #9CA3AF; }
    @media (max-width: 768px) {
      header h1 { font-size: 1.5rem; }
      th, td { padding: 10px 8px; font-size: 0.95rem; }
      .btn { padding: 8px 16px; font-size: 0.95rem; }
    }
  </style>
</head>
<body>
  <div class="container">
    <header>
      <h1>🔓 Universal SIM Unlock Tool</h1>
      <p>Country-wise carrier unlock codes — Free, Secure & Fast Access Worldwide!</p>
    </header>
    <table>
      <thead>
        <tr>
          <th>Country</th>
          <th>Carrier</th>
          <th>Unlock Code</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($unlock_data as $row): ?>
          <tr>
            <td><?= htmlspecialchars($row['country']) ?></td>
            <td><?= htmlspecialchars($row['carrier']) ?></td>
            <td><?= htmlspecialchars($row['code']) ?></td>
            <td><a class="btn" href="?redirect=<?= urlencode($row['link']) ?>">Unlock</a></td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
    <section class="guide">
      <h2>📖 How to Unlock</h2>
      <ol>
        <li>Select your country and carrier above.</li>
        <li>Click "Unlock" button to proceed to the tool page.</li>
        <li>Follow the instructions on the destination website.</li>
        <li>Enjoy your unlocked mobile device!</li>
      </ol>
    </section>
    <footer>
      &copy; <?= date('Y') ?> nirobtech.com. Powered by Uzzol & OpenAI.
    </footer>
  </div>
</body>
</html>
