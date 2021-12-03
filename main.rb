require 'sinatra'
require 'securerandom'
require 'salsa20'
require 'chunky_png'
require 'json'
require 'uri'
require 'net/http'

set :bind, '0.0.0.0'
set :port, 8080

$chars = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

def gen_code(length)
  code = ""
  for i in 0..length-1
    code += $chars.sample.upcase
  end
  return code
end

def gen_key()
  return SecureRandom.random_bytes(32)
end

def gen_nonce(bytes)
  return SecureRandom.random_bytes(bytes)
end

def encrypt(code, nonce)
  return Salsa20.new(Array(ENV['key']).pack("H*"), nonce).encrypt(code).unpack("H*")
end

def decrypt(encrypted, nonce)
  return Salsa20.new(Array(ENV['key']).pack("H*"), Array(nonce).pack("H*")).decrypt(Array(encrypted).pack("H*"))
end

get '/' do
  response = JSON.parse(Net::HTTP.get_response(URI('https://captcha.prussia.dev/captcha')).body)
  challenge_url = 'https://captcha.prussia.dev/challenge/'+response['image']+"?nonce="+response['nonce']
  challenge_code = response['code']
  challenge_nonce = response['nonce']
  erb :index, :locals => {:challenge_url => challenge_url, :challenge_code => challenge_code, :challenge_nonce => challenge_nonce, :completed => false}
end

post '/' do
  response = JSON.parse(Net::HTTP.post_form(URI('https://captcha.prussia.dev/captcha'), {'code' => request['code'], 'nonce' => request['nonce'], 'guess' => request['answer']}).body)
  if response['success']
    return erb :index, :locals => {:completed => true, :success => true}
  else
    return erb :index, :locals => {:completed => true, :success => false}
  end
end

get '/captcha' do
  # return json of image url, nonce and encrypted text of code
  nonce = gen_nonce(8)
  encrypted = encrypt(gen_code(6), nonce)
  return "{
    \"image\": \""+encrypted.join('')+".png\",
    \"code\": \""+encrypted.join('')+"\",
    \"nonce\": \""+nonce.unpack("H*").join('')+"\"
  }"
end

post '/captcha' do
  # decrypt code in post request and check if matches with answer in post
  if decrypt(request['code'], request['nonce']) == request['guess']
    return "{\"success\": true}"
  else
    return "{\"success\": false}"
  end
end

get '/challenge/:encrypted.png' do
  # decrypt and generate image
  # ?nonce=xxx
  code = decrypt(params['encrypted'], params['nonce'])
  valid = code.chars.map { |char| char.downcase }.all? { |char| $chars.include? char }
  if !valid
    return "Error: invalid code"
  end
  #generate image
  image = ChunkyPNG::Image.new(210, 70, ChunkyPNG::Color::WHITE)
  for i in 1..code.chars.length
    char_img = ChunkyPNG::Image.from_file("chars/"+code.chars[i-1].upcase+".png")
    for j in 1..50+rand(40)
      char_img.compose_pixel(rand(char_img.width), rand(char_img.height), ChunkyPNG::Color::BLACK)
      char_img.compose_pixel(rand(char_img.width), rand(char_img.height), ChunkyPNG::Color::WHITE)
    end
    if rand > 0.5
      char_img = char_img.resample_bilinear(char_img.width/2, char_img.height/2)
      char_img = char_img.resample_bilinear(char_img.width*2, char_img.height*2)
    end
    image = image.compose(char_img, (i-1)*30+3+rand(5), 14+rand(12))
    #random rotations??
  end
  for j in 1..250+rand(125)
    image.compose_pixel(rand(image.width), rand(image.height), ChunkyPNG::Color::BLACK)
  end
  for j in 1..8+rand(8)
    image.line_xiaolin_wu(rand(image.width), rand(image.height), rand(image.width), rand(image.height), ChunkyPNG::Color::BLACK)
  end
  for j in 1..5+rand(3)
    image.bezier_curve([ChunkyPNG::Point.new(rand(image.width), rand(image.height)), ChunkyPNG::Point.new(rand(image.width), rand(image.height)), ChunkyPNG::Point.new(rand(image.width), rand(image.height))], ChunkyPNG::Color::BLACK)
  end
  #blur
  image = image.resample_bilinear(210/2, 70/2)
  image = image.resample_bilinear(210, 70)
  content_type 'image/png'
  return image.to_blob(:fast_rgba)
end