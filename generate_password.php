<?php
// 临时脚本：生成管理员密码哈希

define('NOW_TIME', time());
define('THINK_PATH', './ThinkPHP/');
define('APP_PATH', './Modules/');
define('APP_DEBUG', true);
define('BIND_MODULE', 'Common');

require './ThinkPHP/ThinkPHP.php';

// 获取配置的密码密钥
$pwd_key = C('SELLER_PWD_KEY');

// 要设置的密码
$password = 'admin123';

// 生成加密密码
$encrypted = think_ucenter_encrypt($password, $pwd_key);

echo "新密码: admin123\n";
echo "加密后: $encrypted\n";
echo "\nSQL 更新语句:\n";
echo "UPDATE dejavutech_seller SET s_passwd='$encrypted' WHERE s_uname='zhrrobert

';\n";
?>