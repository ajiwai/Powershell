#ファイル名：file_update_timestamp.ps1
#機能説明：ファイルの登録日・更新日を一括更新
#
#起動コマンド例（C:\work\dummyフォルダ以下のファイルの登録日・更新日を日付設定ファイル（C:\work\dummy\date.tsv）の内容に更新する。区切り文字はタブ）
#.\file_update_timestamp.ps1 C:\work\dummy ‘C:\work\dummy\date.tsv’ $FALSE “`t”
#日付設定ファイル例（ヘッダは固定）
#Filename	CreationTime	LastWriteTime
#dummy.txt	2017/07/11 09:43:57	2017/07/11 17:52:59
#dummy2.txt	2017/07/12 09:23:13	2017/07/12 17:44:29
#dummy3.txt	2017/07/13 09:02:39	2017/07/13 18:53:49
Param([string] $paramDirectory, [string] $paramTimestampFile, [boolean] $isFindSubDirectory = $FALSE, [string] $paramDelimiter = “`t”)

if($isFindSubDirectory){
	$a = Get-ChildItem $paramDirectory –recurse #サブディレクトリも取得したい場合は、 –recurseを付ける
} else {
	$a = Get-ChildItem $paramDirectory\*.*
}

Import-Csv $paramTimestampFile -Delimiter $paramDelimiter | ForEach-Object {
	$targetFileName = $_.Filename
	foreach($x in $a) {
		if($targetFileName -eq $x.Name){
			$creationTime = $_.CreationTime
			$lastWriteTime = $_.LastWriteTime
			Set-ItemProperty $x.FullName -Name CreationTime -Value $_.CreationTime
			Set-ItemProperty $x.FullName -Name LastWriteTime -Value $_.LastWriteTime
			echo “changed timestamp`t$x`t$creationTime`t$lastWriteTime”
		}
	}

}