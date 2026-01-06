<?php
// 密码加密函数
function think_ucenter_encrypt($data, $key, $expire = 0)
{
    $key = md5($key);
    $data = base64_encode($data);
    $x = 0;
    $len = strlen($data);
    $l = strlen($key);
    $char = '';
    for ($i = 0; $i < $len; $i++) {
        if ($x == $l)
            $x = 0;
        $char .= substr($key, $x, 1);
        $x++;
    }
    $str = sprintf('%010d', $expire ? $expire + time() : 0);
    for ($i = 0; $i < $len; $i++) {
        $str .= chr(ord(substr($data, $i, 1)) + (ord(substr($char, $i, 1))) % 256);
    }
    return str_replace('=', '', base64_encode($str));
}

// SELLER_PWD_KEY 需要从 config 表读取
// 这里先用一个默认值测试
$key = 'IA=~(D9-|.^k7JsP1p*nVa,W/t6O#KY:$05q3G;)';
$password = '123456';

$encrypted = think_ucenter_encrypt($password, $key);

echo "密码: $password\n";
echo "加密后: $encrypted\n";
?>