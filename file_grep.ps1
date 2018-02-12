#ファイル名：file_grep.ps1
#機能説明：GREPする
#
#起動コマンド例（C:\workフォルダ（サブフォルダも含む）以下の拡張子txtより文言「”abc”」がヒットする行をGREPして前1行後ろ2行を表示する）
#.\file_grep.ps1 “`”abc`” C:\work” txt $TRUE 0 1 2
Param([string] $paramPettern, [string] $paramDirectory, [string] $paramFileType, [boolean]$isFindSubDirectory = $FALSE, [int]$paramBefore = 0, [int]$paramAfter = 0)

$path = “$paramDirectory\*.$paramFileType”
if($isFindSubDirectory){
	Select-String $paramPettern (dir -recurse $path) -Context $paramBefore,$paramAfter #サブディレクトリも取得したい場合は、 –recurseを付ける
}else{
	Select-String $paramPettern (dir $path) -Context $paramBefore,$paramAfter
}
