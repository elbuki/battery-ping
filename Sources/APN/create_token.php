<?php
function base64url_encode($binary_data) { return strtr(rtrim(base64_encode($binary_data), '='), '+/', '-_'); }

function apns_jwt_token($team_id, $key_id, $private_key_pem_str)
{
    if (! function_exists('openssl_get_md_methods') || ! in_array('sha256', openssl_get_md_methods())) throw new Exception('Requires openssl with sha256 support');

    $private_key = openssl_pkey_get_private($private_key_pem_str);
    if (! $private_key) throw new Exception('Cannot decode private key');

    $msg = base64url_encode(json_encode([ 'alg' => 'ES256', 'kid' => $key_id ])) . '.' . base64url_encode(json_encode([ 'iss' => $team_id, 'iat' => time() ]));
    openssl_sign($msg, $der, $private_key, 'sha256');

    // DER unpacking from https://github.com/firebase/php-jwt
    $components = [];
    $pos = 0;
    $size = strlen($der);
    while ($pos < $size) {
        $constructed = (ord($der[$pos]) >> 5) & 0x01;
        $type = ord($der[$pos++]) & 0x1f;
        $len = ord($der[$pos++]);
        if ($len & 0x80) {
            $n = $len & 0x1f;
            $len = 0;
            while ($n-- && $pos < $size) $len = ($len << 8) | ord($der[$pos++]);
        }

        if ($type == 0x03) {
            $pos++;
            $components[] = substr($der, $pos, $len - 1);
            $pos += $len - 1;
        } else if (! $constructed) {
            $components[] = substr($der, $pos, $len);
            $pos += $len;
        }
    }
    foreach ($components as &$c) $c = str_pad(ltrim($c, "\x00"), 32, "\x00", STR_PAD_LEFT);

    return $msg . '.' . base64url_encode(implode('', $components));
}

$token = apns_jwt_token(
    'BLQ2AFW6YZ',
    'JNZ964YHS4',
    "-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg9Srucjp82Gyeg+8M
gCZVGhqh41rOx8nTrTSbNOaCUhCgCgYIKoZIzj0DAQehRANCAATsbv7UVPNJtjcy
Cn8Px9hTET/Q50i+dDUhU9Yya4ak7dhz2p1VKNyZjRdXCi0X3S162h+v2V9s5J5N
GOYI6DLJ
-----END PRIVATE KEY-----"
);

echo $token;
