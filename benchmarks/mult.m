N=1e2;
n=1e4;

x = rand(n, n)*2^4;

X = double(x);
tic
for i=1:N
   Y=X.*2; 
end
toc

X=single(x);
tic
for i=1:N
   Y=X.*2; 
end
toc

X = uint8(x);
tic
for i=1:N
  Y=X.*2;
end
toc

X = int8(x);
tic
for i=1:N
  Y=X.*2;
end
toc

X = uint16(x);
tic
for i=1:N
  Y=X.*2;
end
toc

X = int16(x);
tic
for i=1:N
  Y=X.*2;
end
toc

X = uint32(x);
tic
for i=1:N
  Y=X.*2;
end
toc

X = int32(x);
tic
for i=1:N
  Y=X.*2;
end
toc

X = uint64(x);
tic
for i=1:N
  Y=X.*2;
end
toc

X = int64(x);
tic
for i=1:N
  Y=X.*2;
end
toc