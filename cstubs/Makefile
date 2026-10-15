CC:=gcc
CFLAGS:=-march=native -mtune=skylake -O3 -flto
BINS:=battery

all: $(BINS)

battery: battery_info.c
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -rf $(BINS)
