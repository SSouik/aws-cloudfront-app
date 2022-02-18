# Get the upstream branch's version
upstream_branch="https://raw.githubusercontent.com/SSouik/aws-cloudfront-app/main/version.json"
upstream_version=$(curl -s ${upstream_branch} | grep '"version":' | cut -d\" -f4 | sed 's/[".]//g')

# Get the current version of the Package
version=$(grep '"version":' version.json | cut -d\" -f4)
current_version=$(echo $version | sed 's/[.]//g')

if [[ $upstream_version -eq $current_version ]]; then
    echo "Skipping release creation"
else
    echo "Creating release for v${version}"
    token=$1

    # Create the release
    curl \
    -X POST \
    -u "SSouik:${token}" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/SSouik/aws-cloudfront-app/releases \
    -d "{\"tag_name\":\"v${version}\",\"name\":\"v${version}\",\"generate_release_notes\":true}\""
fi
