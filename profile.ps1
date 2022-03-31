#-------------------------------    Functions BEGIN   -------------------------------

#######################################################

#del alias:gc -Force
#del alias:gp -Force
function Compare-ImagesMetadata { param ( $exifToolPath = "E:\OneDrive - Region Gotland\PortableApps\5. image\PortableApps\geosetter\tools\" ,$inputA = "E:\Pictures\Badges & Signs & Shablon Art\00 - soulcripple front (2).jpg" ,$inputB = "E:\Pictures\Badges & Signs & Shablon Art\00 - soulcripple front.jpg" ) ; $set1 = .\exiftool.exe -a -u -g1  $inputA ; $set2 = .\exiftool.exe -a -u -g1  $inputB ; Compare-Object $set1 $set2 | select -ExpandProperty inputobject }
function get-tempfilesNfolders { foreach ($folder in @('C:\Windows\Temp\*', 'C:\Documents and Settings\*\Local Settings\temp\*', 'C:\Users\*\Appdata\Local\Temp\*', 'C:\Users\*\Appdata\Local\Microsoft\Windows\Temporary Internet Files\*', 'C:\Windows\SoftwareDistribution\Download', 'C:\Windows\System32\FNTCACHE.DAT')) {$_}  }
function remove-TempfilesNfolders { foreach ($folder in get-tempfilesNfolders) {Remove-Item $folder -force -recurse} }

function clear-Days_Back { param ( $path = "C:\Support\SQLBac\" ,$Daysback = "0" ) $CurrentDate = Get-Date $DatetoDelete = $CurrentDate.AddDays($Daysback) Get-ChildItem $path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item }

function ConvertFrom-Bytes { param ( [string]$bytes, [string]$savepath ) $dir = Split-Path $savepath if (!(Test-Path $dir)) { md $dir | Out-Null } [convert]::FromBase64String($bytes) | Set-Content $savepath -Encoding Byte }


function read-json { param( [Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject] $input ) $json = [ordered]@{}; ($input).PSObject.Properties | % { $json[$_.Name] = $_.Value } $json.SyncRoot }


function ConvertTo-Bytes ( [string]$file ) { if (!$file -or !(Test-Path $file)) { throw "file not found: '$file'" } [convert]::ToBase64String((Get-Content $file -Encoding Byte)) }
function set-FileEncodingUtf8 ( [string]$file ) { if (!$file -or !(Test-Path $file)) { throw "file not found: '$file'" } sc $file -encoding utf8 -value(gc $file) }

function read-paramNaliases ($command) { (Get-Command $command).parameters.values | select name, @{n='aliases';e={$_.aliases}} }
function start-bc ($REMOTE,$LOCAL,$BASE,$MERGED) { cmd /c "C:\Users\crbk01\Desktop\WhenOffline\BeondCompare4\BComp.exe" "$REMOTE" "$LOCAL" "$BASE" "$MERGED" } #todo: replace hardcode with global variable pointing to path

function enter-dir { param ( $Path = '%USERPROFILE%\Desktop\' ) Set-Location $Path }; #if no param, navigate to desktop # 5. 更改工作目录 # 输入要切换到的路径 # 用法示例：cd C:/ # 默认路径：D 盘的桌面

Function invoke-GitSubmoduleAdd([string]$leaf,[string]$remote,[string]$branch) { git submodule add -f --name $leaf -- $remote $branch ; git commit -am $leaf+$remote+$branch } ; #todo: move to git aliases #Git Ad $leaf as submodule from $remote and branch $branch

Function invoke-GitLazy($path,$message) { cd $path ; git lazy $message } ; #todo: move to git aliases

Function invoke-GitLazySilently {Out-File -FilePath .\lazy.log -inputObject (invoke-GitLazy 'AutoCommit' 2>&1 )} ; #todo: parameterize #todo: rename to more descriptive #todo: breakout

function invoke-FuzzyWithEverything($searchstring) { menu @(everything "ext:exe $searchString") | %{& $_ } } #use whatpulse db first, then everything #todo: sort by rescent use #use everything to find executable for fast execution

function read-pathsAsStream { get-childitem | out-string -stream } # filesInFolAsStream ;

function invoke-Everything([string]$filter) {Search-Everything -filter $filter -global}

function get-Childnames { (Get-ChildItem).Name ; Write-Host("") }; # 3. 查看目录 ls & ll

function invoke-Nmake { nmake.exe $args -nologo }; # 1. 编译函数 make

function read-aliases { Get-Alias -Definition alias* | select name }

function invoke-powershellAsAdmin { Start-Process powershell -Verb runAs } #new ps OpenAsADmin

function start-explorer { param ( $Path = $pwd ) Invoke-Item $Path }; # 4. 打开当前工作目录 # 输入要打开的路径 # 用法示例：open C:\ # 默认路径：当前工作文件夹

function search-historyInvoke($searchstring) { $path = get-historyPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{Invoke-Expression $_ } } #search history of past expressions and invokes it, doesn't register the expression itself in history, but the pastDo expression.

function search-historyAppendClipboard($searchstring) { $path = get-historyPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{ Set-Clipboard -Value $_ }} #search history of past expressions and adds to clipboard

function get-historyPath { (Get-PSReadlineOption).HistorySavePath }

function exit-Nrenter { shutdown /r } #reboot

function initialize-profile { & $profile } #reload-profile is an unapproved verb.

function aliasviv { vivaldi "vivaldi://flags" } #todo: use standard browser instead of hardcoded

function invoke-gitCheckout () { & git checkout $args }

function df { get-volume }

function export($name, $value) { set-item -force -path "env:$name" -value $value; }

function Get-AllNic { Get-NetAdapter | Sort-Object -Property MacAddress } # 1. 获取所有 Network Interface

function Get-IPv4Routes { Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript {$_.NextHop -ne '0.0.0.0'} } # 2. 获取 IPv4 关键路由

function Get-IPv6Routes { Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript {$_.NextHop -ne '::'} } # 3. 获取 IPv6 关键路由

function grep($regex, $dir) { if ( $dir ) { ls $dir | select-string $regex return } $input | select-string $regex }

function grepv($regex) { $input | ? { !$_.Contains($regex) } }

function pgrep($name) { Get-Process $name }

function pkill($name) { Get-Process $name -ErrorAction SilentlyContinue | kill }

function read-EnvPaths { ($Env:Path).Split(";") }

function pull () { & get pull $args }

function sed($file, $find, $replace) { if (!$file -or !(Test-Path $file)) { throw "file not found: '$file'" }  (Get-Content $file).replace("$find", $replace) | Set-Content $file }

function touch($file) { "" | Out-File $file -Encoding ASCII }

function read-uptime { Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime'; EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}} } #doesn't psreadline module implement this already?

function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition } #should use more

function aliasCode { & $env:code }

function aliasfifs { get-childitem | out-string -stream }

#-------------------------------    Functions END     -------------------------------


#-------------------------------   Set alias BEGIN    -------------------------------

#set-alias -Name cd -Value enter-dir -Option AllScope
#set-alias -Name gc -Value checkout
#set-alias -Name gp -Value pull
set-alias -Name lsx -Value get-Childnames

set-alias -name code -value aliasCode
set-alias -Name filesinfolasstream -Value aliasfifs
set-alias -Name bcompare -Value start-bc 

set-alias -name EveryGitRepo -Value aliasEFunc

set-alias -name GitAdEPathAsSNB -value invoke-GitSubmoduleAdd
set-alias -name GitUp -value invoke-GitLazy
set-alias -name gitSilently -Value invoke-GitLazySilently
set-alias -name gitSingleRemote -Value alia
set-alias -name executeThis -value invoke-FuzzyWithEverything

aliasExecuinvoke-GitLazye filesinfolasstream -Value read-pathsAsStream
set-alias -name everything -value invoke-Everything
set-alias -Name make -Value invoke-Nmake
set-alias -name MyAliases -value read-aliases
set-alias -Name OpenAsADmin -Value invoke-powershellAsAdmin
set-alias -Name open-current-folder -Value start-explorer
set-alias -name pastDo -value search-historyInvoke
set-alias -name pastDoEdit -value search-historyAppendClipboard
set-alias -name pshelHistorypath -value (Get-PSReadlineOption).HistorySavePath
set-alias -Name reboot -Value exit-Nrenter
set-alias -Name browserflags -Value aliasviv
set-alias -Name df -Value get-volume
set-alias -name read-EnvPaths -value printpath
set-alias -name reload -value reloadProfile
set-alias -name unzip -value unzipf    
set-alias -name uptime -value read-uptime

set-alias -Name getnic -Value Get-NetAdapter | Sort-Object -Property MacAddress # 1. 获取所有 Network Interface
set-alias -Name ll -Value Get-ChildItem            
set-alias -Name getip -Value Get-IPv4Routes
set-alias -Name getip6 -Value Get-IPv6Routes      
set-alias -Name os-update -Value Update-Packages


echo "Alias set"
#-------------------------------    Set alias END     -------------------------------


