# ~/.bash.d/99-utils.sh
mytools() { # => List all custom shell aliases and functions
    echo "=========================================================="
    echo "   My Custom Bash Tools      "
    echo "=========================================================="
    echo -e "\033[1;34mFunctions:\033[0m"
    # Note the change here: parsing ~/.bash.d/*.sh instead of ~/.bashrc
    awk -F'[(]' '/^[a-zA-Z0-9_-]+\(\).*# => / {
        name = $1;
        desc = substr($0, index($0, "# => ") + 5);
        printf "  - \033[1;36m%-25s\033[0m %s\n", name, desc;
    }' ~/.bash.d/*.sh | sort
    echo ""
    echo -e "\033[1;32mAliases:\033[0m"
    awk -F'[= ]' '/^alias [a-zA-Z0-9_-]+=.*# => / {
        name = $2;
        desc = substr($0, index($0, "# => ") + 5);
        printf "  - \033[1;36m%-25s\033[0m %s\n", name, desc;
    }' ~/.bash.d/*.sh | sort
    echo "=========================================================="
}