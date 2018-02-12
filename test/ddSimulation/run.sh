#!/bin/bash
# dd 命令模擬備份裝置


if [ "`id -u`" != "0" ]; then
    echo "請使用 root 身分執行。"
    exit 1
fi


echo "# 一、 創建假裝置"
echo
echo "#  名稱              | 描述"
echo "# :----              |:----"
echo "# --------------------------------"
echo "# 模擬原始裝置"
echo "# --------------------------------"
echo "#  vdev-origin-1.img | GTP 分區表。"
echo "#  vdev-origin-2.img | ext4 儲存裝置。"
echo "# --------------------------------"
echo "# 模擬備份裝置"
echo "# --------------------------------"
echo "#  vdev-backup-1.img | 複製 vdev-origin-1.img 的環境。"
echo "#  vdev-backup-2.img | 複製 vdev-origin-2.img 的環境。"

for idx in {1..2}
do
    dd if=/dev/zero of=vdev-origin-${idx}.img bs=4096 count=2048
    dd if=/dev/zero of=vdev-backup-${idx}.img bs=4096 count=2048
done

echo
echo "# GTP 分區表"
echo "#   * 1: 1M 大小、8300 Linux filesystem 分區類型"
echo "#   * 2: 2M 大小、0700 Microsoft basic data 分區類型"
echo "#   * 3: 3M 大小、2700 Windows RE 分區類型"

sgdisk --zap-all --clear --mbrtogpt vdev-origin-1.img
sgdisk -n  1:2048:4095   -t 1:8300  -c 1:'Linux filesystem'  vdev-origin-1.img
sgdisk -n  2:4096:8191   -t 2:0700  -c 2:'Microsoft basic data'  vdev-origin-1.img
sgdisk -n  3:8192:14336  -t 3:2700  -c 3:'Windows RE'  vdev-origin-1.img

echo
echo "# ext4 儲存裝置"
echo "#   * ext4 格式化"
echo "#   * /etc/fstab"

mkfs.ext4 vdev-origin-2.img
mkdir mnt.tmp
mount vdev-origin-2.img mnt.tmp
mkdir mnt.tmp/etc
echo "# 假資料

# UUID=99ef703b-9151-4998-90d1-a44ae4ae7715
/dev/sdd2               /               ext4            rw,relatime,data=ordered        0 1

efivarfs                /sys/firmware/efi/efivars       efivarfs        rw,nosuid,nodev,noexec  0 0

# UUID=953E-0778
/dev/sdd1               /boot           vfat            rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro      0 2

# UUID=f1b9d229-bc7f-4220-b42c-9383354abd7d
/dev/sdd3               /home           ext4            rw,relatime,data=ordered        0 2

# UUID=35f27c6e-094c-4f6a-be71-d7c706b4405b
/dev/loop0              /mnt            ext4            rw,relatime,data=ordered        0 2
" > mnt.tmp/etc/fstab
umount mnt.tmp
rm -rf mnt.tmp

echo
echo
echo "# 主角登場"
echo "$ ../../bin/ptclHelper vdev.ptclHelper vdev-origin-1.img vdev-origin-2.img"

../../bin/ptclHelper vdev.ptclHelper vdev-origin-1.img vdev-origin-2.img

echo
echo
echo "# 備份還原"
echo "$ cd vdev.ptclHelper"
echo "$ ./restore.sh ../vdev-backup-1.img ../vdev-backup-2.img"

cd vdev.ptclHelper
./restore.sh ../vdev-backup-1.img ../vdev-backup-2.img

echo
echo
echo "# 對比"
echo "$ ../../bin/ptclHelper blkid vdev-*.img"
echo "# or ../../bin/ptclHelper info vdev-*.img"

cd ../
../../bin/ptclHelper blkid vdev-*.img

