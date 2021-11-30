#!/usr/bin/env stack
-- stack --resolver lts-18.7 script --package shake

import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

data Settings = Settings {
-- Path to the singularity image file
-- required; create with "singularity_build_sif.sh"
-- that's not part of the pipeline, because it requires sudo permissions
  singularityContainer :: FilePath
-- Path to mount into the singularity container
-- https://sylabs.io/guides/3.0/user-guide/bind_paths_and_mounts.html
, bindPath :: String
-- How to run normal commands
, qsubCommand :: String
}

mpiEVAClusterSettings = Settings {
  singularityContainer = "singularity_experiment.sif"
, bindPath = "" -- "--bind=/mnt/archgen/users/schmid"
, qsubCommand =  "qsub -sync y -b y -cwd -q archgen.q -pe smp 1 -l h_vmem=1G -now n -V -j y -o ~/log -N example"
}

relevantRunCommand :: Settings -> FilePath -> Action ()
relevantRunCommand (Settings singularityContainer bindPath qsubCommand) x
  | takeExtension x == ".R"  = cmd_ "singularity" "exec" singularityContainer bindPath "Rscript" x -- cmd_ qsubCommand "singularity" "exec" bindPath singularityContainer "Rscript" x
  -- | takeExtension x == ".sh" = cmd_ qsubCommand "singularity" "exec" bindPath singularityContainer x

infixl 8 %$
(%$) :: FilePath -> ([FilePath], [FilePath]) -> Rules ()
(%$) script (inFiles, outFiles) =
  let settings = mpiEVAClusterSettings
  in outFiles &%> \out -> do
    need $ [script, singularityContainer settings] ++ inFiles
    relevantRunCommand settings script

infixl 9 -->
(-->) :: a -> b -> (a,b)
(-->) x y = (x,y)

input x = "input" </> x
intermediate x = "intermediate" </> x
scripts x = "scripts" </> x
output x = "output" </> x

main :: IO ()
main = shakeArgs shakeOptions {shakeFiles = "_build"} $ do
  want [output "3D.png"]
  scripts "A.R" %$ [input "raw_input.csv"] --> [intermediate "dens_surface.RData"]
  scripts "B.R" %$ [ ] --> [intermediate "colours.RData"]
  scripts "C.R" %$ map intermediate ["dens_surface.RData", "colours.RData"] --> [output "3D.png"]

