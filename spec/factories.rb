Factory.define :user do |u|
  u.github_login { /\w+/.gen }
  u.login {|u| u.github_login }
  u.email { /\w+@gmail.com/.gen }
  u.password 'tintinpouet'
  u.password_confirmation  'tintinpouet'
end
