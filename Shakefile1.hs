#!/usr/bin/env stack
-- stack --resolver lts-18.7 script --package shake

import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
 
main :: IO ()
main = shake shakeOptions {shakeFiles = "_build"} $ do

  want [ "output" </> "3D.png" ]
  
  "output" </> "3D.png" %> \out -> do
    let script = "scripts" </> "C.R"
        dataFiles = [
          "intermediate" </> "dens_surface.RData", 
          "intermediate" </> "colours.RData" 
          ]
    need $ script : dataFiles
    cmd_ "Rscript" script

  "intermediate" </> "dens_surface.RData" %> \out -> do
    let script = "scripts" </> "A.R"
        dataFiles = [ "input" </> "raw_input.csv" ]
    need $ script : dataFiles
    cmd_ "Rscript" script

  "intermediate" </> "colours.RData" %> \out -> do
    let script = "scripts" </> "B.R"
    need [ script ]
    cmd_ "Rscript" script
