Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '9d9e57b0ab26c68676b416bd799a719a', '0e509e799d502471370f3f2f5b2b49bc'
  provider :twitter, 'mWEoLrc20zYgvzOwVuynWg', 'HpsFpVSnyg2CD1Yedn6jqa6vfbgKtPLN3DgxN0SsVU'
end
