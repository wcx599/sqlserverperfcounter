﻿
while ($true)

{

#counter is "\Memory\Available MBytes"

$counter = "\Memory\Available MBytes"
$computername = get-content C:\users\wangchenxu3\servername.txt

$all= (get-counter -ComputerName $computername `
 -Counter $counter).counterSamples | `
 select path , cookedValue

      $InsertSQL=""
      $currentTime=Get-Date
      $date = $currentTime.ToShortDateString()
      $time = $currentTime.ToLongTimeString()
      
      foreach($PerformanceCounter in $all)
      {
            
          $realvalue=$PerformanceCounter.CookedValue 
          $path = $PerformanceCounter.path
          #split path to 3 parts, [2] [4] [5] for each part
          $ip = ($path -split "\\",0)[2]
          $Category =($path -split "\\",0)[4]
          
          #Default is disk bytes/sec
          #$Label =($path -split "\\",0)[5]  
          
          $Label = "Available MBytes"
          #$value = $realvalue.ToString()
          #compose a batch insert from each records
          $InsertSQL+="INSERT INTO PerfTableMemory(Computer,Category,Label,Value,CaptureTime)
          VALUES('$ip','$Category','$Label','$realvalue',getdate());"
     #VALUES(''"+$path+"'',''"+$curentTime+"'',''"+$realvalue.ToString()+"'');"      
       }
       #make up a sql connection and execute the insert command
      $connectionString3="data source=10.199.83.40;database=PERFDB;uid=perfuser;pwd=perfuser;"
      $conn2=new-object system.Data.SqlClient.SqlConnection($connectionString3)
      $conn2.open()
 
      $cmd2=$conn2.CreateCommand()
 
       $cmd2.CommandText=$InsertSQL
       $cmd2.ExecuteNonQuery()
       $conn2.Close()


       sleep 15

 }
