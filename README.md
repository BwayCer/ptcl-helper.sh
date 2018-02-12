帕蒂瑪其小幫手
=======


> 版本： v0.0.0



## 簡介


通過 `sgdisk` 及 `partclone` 備份工具協助處理的備份小幫手。

懂她的電腦，卻不懂她的心；
摸過她的滑鼠，卻不曾牽過她的手；
處裡了那麼多 Bug，卻還沒收到 return Answer。

學妹 ~~_的電腦_~~ 需要靠你來拯救！
工具人， 帕蒂瑪其會是你的好幫手。




## 備份須知


### 相關名稱


 名稱                                 | 描述
:----                                 |:----
partclone.log                         | 備份工具 `partclone` 的日誌。
deviceFile.tar.gz                     | 裝置文件的壓縮文件，程式處理時的過度文件（正常結束時會將其刪除）。
hostInfo.txt                          | 裝置資訊，可查看備份內容或比對還原後的差異。
restore.sh                            | 還原腳本。
clone.sh                              | 備份腳本。
deviceFile\_\*.partitionData          | 備份分區數據的裝置文件。
deviceFile\_\*.img                    | 備份格式化數據及儲存資料的裝置文件。
wrapDeviceFile/                       | 打包裝置目錄，儲放壓縮的裝置文件。
wrapDeviceFile/deviceFile.tar.gz.\*   | 壓縮分段的裝置文件，利於保存與移動。
deviceFile.md5                        | 裝置文件的校驗碼。
wrapDeviceFile.md5                    | 打包裝置文件的校驗碼。

重要需被保存的文件為
hostInfo.txt、restore.sh、clone.sh
、wrapDeviceFile/deviceFile.tar.gz.\*
、deviceFile.md5、wrapDeviceFile.md5
， 其餘可視情況刪除。



### 注意事項


1. **可用空間必須為備份或還原的已使用空間的三倍以上，**
   裝置文件、壓縮文件、打包裝置目錄 各佔據一份空間。
1. 對非 `GPT` 分區表的裝置使用 `sfdisk -d <device>` 命令備份。
1. **在對 `Dos` 分區表的 Window 10 上裝置備份分區數據測試失敗。**



## 要求


* `sgdisk` 、 `partclone` 工具。



## 使用方法


先關使用方法可透過 `--help` 來查看， 例如：

```
$ ./bin/ptclHelper --help
# 備份小幫手，通過 sgdisk 及 partclone 備份裝置。
# `partclone` 相關選項可以查看 `man partclone` 說明。
# `split` 相關選項可以查看 `man split` 說明。

用法： [命令] [選項] <備份儲存位置> <裝置 ex: "/dev/sdx","/dev/sdxN">[...]


命令：

  blkid     顯示 `blkid` 資訊。
  info      留存當前裝置資訊供還原後對照。
  wrap      壓縮、分段及還原。
  md5       建立校驗碼。


選項：

      --preview              預覽將被執行的命令。
  -D, --domain               Create ddrescue domain log from source device.
                             `partclone` 相關選項。
      --offset_domain <X>    Add offset X (bytes) to domain log values.
                             `partclone` 相關選項。
      --restore_raw_file     create special raw file for loop device.
                             `partclone` 相關選項。
  -R, --rescue               即使有錯誤仍繼續執行。 `partclone` 相關選項。
  -C, --no_check             不要檢查設備的大小和可用空間。
                             `partclone` 相關選項。
  -N, --ncurse               Using Ncurses User Interface.
                             `partclone` 相關選項。
  -X, --dialog               Output message as Dialog Format.
                             `partclone` 相關選項。
  -I, --ignore_fschk         忽略檔案系統檢查。 `partclone` 相關選項。
      --ignore_crc           忽略 crc 檢查。 `partclone` 相關選項。
  -F, --force                強制執行。 `partclone` 相關選項。
  -f, --UI-fresh <sec>       Fresh times of progress.  `partclone` 相關選項。
  -z, --buffer_size <size>   讀取或寫入的緩衝區大小。 預設為 1048576。
                             `partclone` 相關選項。
  -d, --debug <level>        設定除錯層級 [1|2|3]。 `partclone` 相關選項。
  -a, --average <sizeMB>     均分分段文件，以 MB 為單位。 預設選項，值為 256MB。
  -b, --bytes <size>         以大小分段文件。 `split` 相關選項。
  -n, --number <chunks>      以數量分段文件。 `split` 相關選項。
  -h, --help                 幫助。
```

