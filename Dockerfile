# e.g. --build-args=ARCH=arm64v8 (armhf, amd64, i386...)
arg ARCH=i386
FROM $ARCH/alpine as builder

run apk add --no-cache alpine-sdk git readline-dev
arg LUAVER=5.1

workdir /work
run git clone https://github.com/viruscamp/luadec
run cd luadec ; git submodule update --init lua-$LUAVER
run cd luadec/lua-$LUAVER ; make -j8 linux
run cd /work/luadec/luadec ; make -j8 LUAVER=$LUAVER

FROM $ARCH/alpine as runner
workdir /app
copy  --from=builder /work/luadec/luadec/luadec /app/luadec
ENV PATH=$PATH:/app
ENTRYPOINT /app/luadec
