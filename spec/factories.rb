Factory.define :user do |u|
  u.github_login { /\w+/.gen }
  u.login {|u| u.github_login }
  u.email { /\w+@gmail.com/.gen }
  u.password 'tintinpouet'
  u.password_confirmation  'tintinpouet'
end

Factory.define :repository do |r|
  r.owner { /\w+/.gen }
  r.name { /\w+/.gen }
  r.url {|u| "http://github.com/#{u.owner}/#{u.name}" }
  r.atom_url {|u| "#{u.url}/commits/master.atom" }
end

Factory.define :coder do |c|
  c.login { /\w+/.gen }
  c.atom_url { |co| "http://github.com/#{co.login}.atom" }
end
