#ファイル名：file_check_by_timestamp.ps1
#機能説明：任意のフォルダ配下のファイルを任意の日時（日・時・分）前以降のファイルのみ抽出する
#
#起動コマンド例（C:\workフォルダ（サブフォルダも含む）以下の拡張子classの最終更新日が現在日時より0日2時間45分前以降のファイルを表示）
#.\file_check_by_timestamp.ps1 C:\work class $TRUE 0 2 45
Param([string] $paramDirectory, [string] $paramFileType, [boolean]$isFindSubDirectory = $FALSE, [int]$paramFromDays = 0, [int]$paramFromHours = 0, [int]$paramMinutes = 0)

if($isFindSubDirectory){
	$a = Get-ChildItem $paramDirectory -include *.$paramFileType –recurse #サブディレクトリも取得したい場合は、 –recurseを付ける
} else {
	$a = Get-ChildItem $paramDirectory\*.$paramFileType
}

foreach($x in $a) {
	$days = ((Get-Date) – $x.LastWriteTime).Days #作成日の場合はCreationTime
	$hours = ((Get-Date) – $x.LastWriteTime).Hours #作成日の場合はCreationTime
	$minutes = ((Get-Date) – $x.LastWriteTime).Minutes #作成日の場合はCreationTime

	$isSkip = $TRUE
	if ($days -lt $paramFromDays -and $x.PsISContainer -ne $True){
		$isSkip = $FALSE
	}
		if ($days -eq $paramFromDays -and $hours -lt $paramFromHours -and $x.PsISContainer -ne $True){
	$isSkip = $FALSE
	}
	if ($days -eq $paramFromDays -and $hours -eq $paramFromHours -and $minutes -lt $paramFromMinutes -and $x.PsISContainer -ne $True){
		$isSkip = $FALSE
	}

	if(!$isSkip){
		# echo $x #該当ファイル情報を表示
		#該当ファイル情報を表示
		$creationTime = ([DateTime]$x.CreationTime).ToString(“yyyy/MM/dd HH:mm:ss”)
		$lastWriteTime = ([DateTime]$x.LastWriteTime).ToString(“yyyy/MM/dd HH:mm:ss”)
		$name = $x.FullName
		$length = $x.Length
		echo “$name`t$creationTime`t$lastWriteTime`t$length”
		# ii $x.Directory #エクスプローラーでフォルダを開く
	}
}
