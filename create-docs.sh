# Create the documentation for TDCAppDependencies
jazzy \
--author "Josh Campion @ The Distance" \
--author_url "https://thedistance.co.uk" \
--github_url "https://github.com/thedistance/TheDistanceComponents" \
--xcodebuild-arguments -scheme,"TDCAppDependencies" \
--module "TDCAppDependencies" \
--readme "ReadMe-TDCAppDependencies.md" \
--output "docs/TDCAppDependencies"

# Create the documentation for TDCContentLoading
jazzy \
--author "Josh Campion @ The Distance" \
--author_url "https://thedistance.co.uk" \
--github_url "https://github.com/thedistance/TheDistanceComponents" \
--xcodebuild-arguments -scheme,"TDCContentLoading" \
--module "TDCContentLoading" \
--readme "ReadMe-TDCContentLoading.md" \
--output "docs/TDCContentLoading"
