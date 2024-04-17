if [ ! -d ~/.rick ]; then
    mkdir ~/.rick
fi
mv rick ~/.rick/rick
echo -e "alias rick=~/.rick/rick\n" >> ~/.bashrc
