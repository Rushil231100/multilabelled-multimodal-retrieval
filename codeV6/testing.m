function a = testing %#codegen
    a = ones(1000000,256);  
    r = rand(1000000,256);
  for i = 1:100000
    a(i,:) = real(fft(r(i)));
  end
end