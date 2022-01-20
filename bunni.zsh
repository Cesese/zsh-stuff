# Based on elite2 and mutahar's prompt on a youtube video (probably a default one on kali linux)
## Created by Bunni

prompt_bunni_help () {
  cat <<EOH
This prompt is color-scheme-able.  You can invoke it thus:

  $ prompt bunni [-t <text-color>] [-p <punctuation-color>]
      [-b <background-color>] [-f <bold/double/default>]

The default text and punctuation colors are none, with a blue background.
This theme works best with a dark background.

Recommended fonts for this theme: either UTF-8, or nexus or vga or similar.
If you don't have any of these, the 8-bit characters will probably look
bad.
EOH
}

prompt_bunni_setup () {
	# Set defaults
	## Color
	local default_color1='%f'
	local default_color2='%f'
	local default_color3='%K{blue}'
  local text_col=${default_color1}
  local punct_col=${default_color2}
  local back_col=${default_color3}
  ## Punct
  local U2500="─"
  local U250C="┌"
  local U2514="└"
  local U2501="━"
  local U250F="┏"
  local U2517="┗"
  local U2550="═"
  local U2554="╔"
  local U255A="╚"
  local dash="$U2500"
  local ulCorner="$U250C"
  local dlCorner="$U2514"

	while [ "$#" -gt "1" ]
	do
		case $1 in
			'-T'|'--theme'*)
				# User made themes. Feel free to change them.
				theme=$2
				case $theme in
					'user')
						text_col='%F{yellow}'
					;;
					'admin')
						text_col='%F{cyan}'
					;;
					'root')
						text_col='%f'
					;;
				esac
				shift 2
			;;
			'-t'|'--text'*)
				if [ "$2" = "" ]
				then
					text_col='%f'
				else
					text_col="%F{$2}"
				fi
				shift 2
			;;
			'-p'|'--punctuation'*)
				if [ "$2" = "" ]
				then
					punct_col='%f'
				else
					punct_col="%F{$2}"
				fi
			shift 2
			;;
			'-b'|'--background'*)
				if [ "$2" = "" ]
				then
					back_col='%f'
				else
					back_col="%K{$2}"
				fi
			shift 2
			;;
			'-f'|'--form'*)
				case $2 in
					'b'|'bold')
						dash="$U2501"
						ulCorner="$U250F"
						dlCorner="$U2517"
					;;
					'd'|'double')
						dash="$U2550"
						ulCorner="$U2554"
						dlCorner="$U255A"
					;;
					*)
						dash="$U2500"
						ulCorner="$U250C"
						dlCorner="$U2514"
					;;
				esac
			shift 2
			;;
			*)
				#prompt_bunni_help
				break
			;;
		esac
	done
  
  # Assemble

  local text="%b$text_col%k"
  local parens="%B$punct_col%k"
  local punct="%B$punct_col%k"
  local background="%b%f$back_col"
  local reset="%b%f%k"
  
  local lpar="$parens($text"
  local rpar="$parens)$text"
  local lbra="$parens"'['"$text"
  local rbra="$parens"']'"$text"

  PS1="$punct$ulCorner$dash$dash$text$lpar$background%n@%m$rpar$punct$dash$text$lbra%B%~$rbra$punct$reset$prompt_newline$punct$dlCorner$dash\$$reset " 

  PS2="$parens$text$punct-$reset "

  prompt_opts=(cr subst percent)
}

prompt_bunni_preview () {
  local color colors options
  #        1  1   1        2        2      2
  colors=('' '' 'user'  'green' 'magenta' '') # they go in groups of 3: text color, punctuation color, theme

  if (( ! $#* )); then
  	s=3
    for i in `seq 1 $s $#colors`; do
    	j=$(( $i + 1 ))
    	k=$(( $i + 2 ))
      color=$colors[$i]
      color2=$colors[$j]
      color3=$colors[$k]
      options=()
      [[ ! "$color" = '' ]] && options=($options '--textColor' "$color")
      [[ ! "$color2" = '' ]] && options=($options '--punctuationColor' "$color2")
      [[ ! "$color3" = '' ]] && options=($options '--theme' "$color3")
      prompt_preview_theme bunni $options
      (( i < $(($#colors - $s)) )) && print
    done
  else
    prompt_preview_theme bunni "$@"
  fi
}

prompt_bunni_setup "$@"
