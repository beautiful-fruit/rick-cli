# rick-cli

## Install
```bash
make
```

## Custom video
### 0.Remove `imgs` directory(if exist)

### 1.Convert video to images
```
ffmpeg -i <input video> -vf "scale=-1:64" imgs/frame_%d.jpg -y
```

### 2.Convert images to c file
```
python convert.py
```

### 3.Finish, and install it
