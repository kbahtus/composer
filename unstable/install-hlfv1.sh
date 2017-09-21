ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.13.0
docker tag hyperledger/composer-playground:0.13.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �=�r�Hv��d3A�IJ��&��;ckl� 	�����*Z"%^$Y���&�$!�hR��[�����7�y�w���^ċdI�̘�A"�O�έ�U���Pp��-���0�c��~[t? ��$�?��)D$!�H��1!���#A�E�����X64xd���Y��=��B����m�,���,dv5Y����6�L�6�d~0`m�O�C����� SGj����1�b�lږK� x�%l	���3V���fb��{��:(T2���b6��?z ��?Q�h���N����Ȇ*�!A�����)!H���X[��A�2e����
�0��ӁU�b"�V,T�*���j�bc����n���jB�@��;���'�ٴy�Rl2i�&�k:Z<��7mM�k��,��,��:�� ���@�U]1(,�`�*^k]qb���^����CM�F>��>C��S�*jP����v�2e� �*2	�-]��3��rL�v�av��PȣD����v\�
��`>S,��m}8Qâ��V'��u̆X�.�U�-���ߴ����Н��LD��9�����#�`����裃,���?�̔�0s���ݧ����oJ1�ɼs;�2&b��pt��`Dq���a��슊���=�.ldPڒI�����>��|�j����j�	��������y�������$Q�?�{�������o#�F���נռkl����_���G#R8,J�\�K����_<�.TӌPZM�� �?}��S5�jL��*)Wv?T�ʩ�[����<��{���S胎!q6�|����3��>]��*�bx-������0C�;Pi�
�[ظ�6���4��O�g~��[���t�����6�c'b��Q�t�h�d�
+����Y�9�ul��Z�Cň�i٠�tg��1�.�i�l�A��D�fc���'<��6���В'M�F7���g�6ƺ��9oS�C�nbs��)��p��k
2,ֶL���a�,�&��:���c{Yӱ�R��?��-�;tB-ڑ��4w�AvÊ������o���h����Ժ�o8z�=�A��C����h�d!���.J�O�`"8<O`��ƥ�>���>"�=IL=�!5�� j��&��������i�v�.��/L�N��� 
�Z����?�	�^�;;�vڠ��:��
L��]D
0�Ќ�襐���,w�orWw(�<}�2>nrZ����H<��v σ��(I���41��H{�6$�^o����� D6�z-�~2�\]#��'�㭇�^��6�f�6`A�N��Y����g��%� �@���(l�G�������w�-�F{<�a�@��c:hW����ߙ���9�YV����>n�U��aC�	�_=<}s�	�.}:ܱ"u8z�\��+9��*Ѿ��|��M2Q.wX����:�ґb�^SS� 3��x��h�<g�	�l���:yo�y���y����l��?���+�	��*m�)�񏲧�d��
���`�ի�T�>�;5��W`]#x�B��rdA�S����K���2ҽ��P���O,_����?_6̐��Z�SK�_���i��翫�OJ��a\��=[`g4��ӧ]=ꎙX�9���LXs�4�4)�5����>�Ηw>A�p��|�C%U�Vw~&�	y��gϳ+{;�gO�Ɛ�h����$^nVN��Ǚr%P|q1�͞�;� 48����I��6m�"�4rLV��8�[h>MB�n�=�|D:Kw*��[����j��98����ڬ��Q��Bd�Tk��&j�Qw�/4�γ?���/���<����۷��̆w�����-	s.�vu�+��k����߇_1���.��%���	oZ	���!O�y�e!~�-
?�E��c�f���l4��y}w�����B|�����ߗ3�д�s�L�#�0���#����_��'���=1:m�dAtյ0�㄰�Aϲ��Νa��O�Kwoc��{���?A_�� ��?��܉n����z�W7]��/;�⑩��Dbk���z����pl�=�i� �&6_�����B�݆�j9��.��Ȧ�X�	�䘈�˩ݝ�f���?�����4���c�����'X�շl�4Ȉ��5�9�EF������tx+�S%�r��t�Fȴ���c�4u�@�Iو{b�A���?��3�o�W�m�=at���G7fB?�5Ģ��"0�Z� ���z�L���ޙ���k8}������v�~pS����e�?.M��D"��[������P!��\��?t�6\]
Y�茨����kAnDk�ǁzO�=n3�BP\���[a+��ަ�w}�Vm`Gi���*��������e��bS��F�����qY,c[k4mP�;���!���^C�p�����]����]^
-���M˿���Ww��y���f7D�;�Ч�C
��6 ��'`�9 ��lc@�v�t:�rJg������hG�$�g! ��ohsZ��!T�n��A� ~�ᬍ���^��]��l)3S�\��l�(k��6�e�IF�d^�/}�t���:�L&�Y���K 1#��Tj���3&Z�N�1+1�D��\�C�J$��j���,� �<ʼ\)cyf�� �܀#l�E�̺�4�1Є1���8R��J���b�f}A��y���j�Oh����b<,���W�^��s�SоX�]���h|��'���+����>p������?�������?Lٟ~B���HR8�UWDE��^�K�V"��a)�H���DDR���&b-�׶�э�������4�y�_���;]#�qD6��o����m�ѷO9.����7�y㟸����__m��I"���7_���<�{����������w���?�!���ߜ�d�jZ�xL���/�)#m0��q~��߬�{�]���3�Vm�^�G���_|����&o������RL����*���c�'�[M%e�Nc����$}��:�?h�M�����S�N���W��5�9[�m|�>AE	��Z]P�[a���@uE�m)	)A�'b[*��$(P܊�DM�C�����&4��� �V��
��($3�|�2�j>�O��+}g��T�<���TC��r#_��΁q\|�WC�\��k8��K�T�4�����B������>� �r�x�I6����E�R.'�cB��j���ޮE^;�$s�=���gJ5}L�i��;Cig�Ӱ~y޺�U�7.�fr���e�9{�l��$��J��.v�2tq
�L��|g�gb�v�J�PUz��|�P��|�����2aX��89O�
%��*���K�\�����2S-����K%{�pւ'g]��V3'�d��E���8
g�|�z=�o���L����띔N�6<��d.�B%��\�Vr�~�حU�gd&��\��1W)H	��ɥR��^fW�r2�l�]$Kb�uQ���~7^|��G�X���I��:�k�N��z��~
��,T+�-���g�^z�X�筂zX��I�~���;�V��Y"kAz��{�d�W�k��H�:׻�BR�oe�sY.�,:*5�+�
�=9�l�gЉ'���;�,�z{폝6��<<80�T6V�¯���˝�����L�BC.d�R�RJ��J�wF*��X��"i^&�'�P�8{O磨b���ݔj���^����*��Lf�B"�T�o���P��))�ţ����`,�)�g�?��`�}l4�5��@:fL�3[?�_�ܐ�/ �bL�=�ԟ	�c{޲�R�D�W���}>��װ��_���L����bt�����cb�^攕>�
��.���"��	=H}�R�!���~rk��֪�sg�Pߠb�D׻z6����^�;M�r�d�lvSV�X��Z�Y����<��)����cN:n�K�h?��Q��x7����q��S=�0T�P����w�j�d���ǜo���s��/~�_�n��k��
�l�ߩ}��/���g��u�ϕ���?J��S��?��ez����GJ.�G!i���K9�=3�M�j�u���,�nt�a;��ٳl��A�S>{�gˉ&�2>�{{��K۰ۆ|��-�w!$v;F���i���3n��{��g��� ����i`I]k����D�c�㿣�:��j�	H�N�dq��d�|3;A �:(�2��5�=�Q���7�}7�m�=˭k������ �5���@:0 �ꚡ��)\�Q]��.ف��Ѐ��ċZVم����X�O��/qJ�k�h@��Ψ Ҹ5c��W���n�R�+��U� �k:���t�c!HT���F`,����ue�ct�ز�_�x��y8�s1�l{����!>(�2�#Ν|h�}0�G��q�v�e:�3�"�t�� ����M�j��hd"g}�=�P;&�  ��Z�G/0���r)�"PEd���^���R��a��� �4a�6HI�lSC��!6`T֧m[�A�{S����=��8 ���GG#ۋMPm2�_ؠ(�K`A����E��I�9Æ���ʀ�&�5Pn5�Mh�� &>�������$к�"_�?�u����h���'fl!�WW���� ��r�`�/$�妭�k�}2�]�;d�u�Yg�}����JD��6_Y�h]�����c�vz���2��.��<)���e|�	n8N����q����T��SA��.�,b�Fpfv��9��\��p���v�7�=�@D*ml"O��K3�|�[4��E.�}� c<��@����_���@�Sy��@O
;��lw�b��#���t3��2K��J�/ݫ�4_�|m��<���9o���;t�I�T5٦��.}**χk���"&���Fv��U�tbhR�c;tB�RQt�"RDt�pl��a����T��ɚ�5(mwtL/��D\6��h�9Th�=ͧ�:�`]��tX�9�	�e�v3���M�}D�����vȒ��c�.�`@0�?��`�td���Eߛ���R�
���g�@�1TU&a(�����-�Dz�o�B[A�#&�X�������]K��XZ��i����)R�
f�L7�K����2%�;�s�<�'�+'v'���N�d��B���@Po���Y��alF Do���s�����B���[���}��9���o��)�8����Ǐ���ԏ�,�ǿ�ϥ���䯨��A�犁���/��߿��o>�������8�=Y �q�����u�c�~ܺ�.&T����T(�	��!9BEk1C�HS�1�")���cd�#H���8A�m)#��I4��گ����o���O���ʏ>�ӹ�������~C��~�����+�����}�6�_���������C�kB)����/��!���-�woA�C Z� �b��E��t3׍F�ǆ���R�M��O�N�����K��%@W!��W��*ć�jL�.�
�QU\K`F6k.�u��"�3�J����%M��\�H�א�g�Y�{�)a_�i�Vi�"
E����9f����1�-��+�f���R�����0�m����	ž�0a�Sn�X�o�3�J�^��f�<�1C(�f��7���%rw�kT#��Su�����1�<M/���9�T��a����~�/�l�/�cM��N�҅j1u�o"�e"����ss�$�e��Hv�l[H`&�Y��t!�2�����@��1���G��I�I�?h�5af��\6i =[�c9+�9�S�$%C;��\'E�T�ϥ��H�fw�f�6Zd��~�;>ob٢Ue��;�Ť�j���%�#�<��屚)S���8��[_�f��8��i�2II�j�l��0J��MJ�͍��+"��B��������<��+��.�K��K��K��K䮸K䮰K䮨K䮠K䮘K䮐K䮈Kd���`�E�,�h"��IR���QJ,P;Ǟ��f5/Ƙ�������Ŷ�!�E��(p.T��|� �sՃ��B�~kՃ �s;�5SV�=ܼ�5S�S?��j��2OM�X1IOCs��7�l�P#��Xn��,��b�ї�2�B-M���Vy*�(K�F���X�6����Im�@]�~W��D�D#�}�caLBbe.;[�r���S9��-M��y�u���'C�f�XG�\"F)� LvH3�3e�L��NL]�!#��~��k�=c�l�O(\2wZQ�r����򈌵Y��o��Y�p�p�wa�.~};�G�>޲�}��Go��[����V7��_½7v���ϐ���-�8��[���HS[��'�w��8r����ɇ:�kP���^<�Eo܁��՗7o^�:pQ��} z��A�_���>r~�G?t��?y����<�ރ�~�(�,-Q&K+���YN�U&�TY.R�Qr����%�E��K�\�'6��e&l��r&	XJ.�6V�`)OWr!������EW��:��2�M	\��+�s@��-�(U��N�Q<�RØ �Y�F)U`�x"�Rq*}̎�J�W@bT>\��ʱ��0�YO�,�PO�-���JK'Mc��z�]]��tG������HM�s���BղTw%�f-��t���f��`D�*�!-�l��2qFjrˁ��hG����q�r�RrtnI����'J�n����%}��)�N6E�G��ZS�|-���ny0�����"�~-gY�l�}�/�-�2B:B3��1���q���nXS��a����a��Z	�,�H��=����d�80����\��Q�/
�4�ᢙ�ޙv��-�?~���,0���3�rbIW\�d��~D<�b�5V�B[_d{�"��Ymd=��g��̬������m��ew��=��tϲ��fU���S��L��=���j"o�:����zR��J�-�%%�A��U�P+�e�φ��Q��Y4b���:/�yzU�>���T�~��
��C�+�@����نr\�i��f�/����Ts�u
�0�I�泎֞G���SkO'�:����J'�L[��dUX,�]Z����Z4�$%���Ų<�ҥ�,�0�6o�����Ţh1L���d*���S*�E�vk�0����4�c�/��hzYxv#��/�䉬�b�H��lPkjd*�1&#w���e��Mv��dd&iG�����!�=��&T&�m�`\e����K��dm�\eR漫P���j�RJC�r�u�V�sH�<ժ.6�X��u�]%��F��wny,�qI�c�z%#�g)�\U�ɐ��Ng*]v'@��V� �F١P"�L]<3���Ҕ���B'=CS��;A�RXH���S(�ͨ�(�w�i�МOqR�T�H�j�y����F�
>*[;LF-�c��ul*���Ps���ʆ���h���R��r�e��٥��]���oY6�#�]�n����"<���eB+��څ<�����-ZTtc��_�Gn�G���,8�U��Tc%� ��>�F^����0���ԥx/���������ϟ�<�BށyD�QR������ʳç����"i�l�����kz���+�7O#R�B��ZgdU� �qD�7�'���q��!9J��t�����u/;�<p��剢� ����S:��u�^�^f�y����n���������0]���B[��!���o����6��'�~0�u�zd�v[�~'אn��;�0�JP�^��`����[�t&ê$=8�&�@1��ؑwR{G���}��rF�������>G�&����W����]= �;�9	~�amT���!�G����y�tu���}f]/���u��+Z�Zu��^���9�щ��z�|.�vL���������"�	:Y�G�	j� �G�~����( �h#��f��D��Z7 D� FW��BE_�oL���v����4Zcp�X�x�,Υ�`�7�zw4���P�t v9�����=_ͩ�� ���|�V�ت���ć��I�I��,�QСwA���9��
Zt��?_} k���������*Ù:��^�5�>蜯6��Dj���Y�A����W���_��'�N\l+Mv�dt��9��u��5��*��:	�]BG^�WĀ��Mt����X�Nl�Z&��C/:��VB ؆��:l�cI;	GV�'0\Y-j%�ȗ[/$�̀\1�ces�7�ןzP���f���	�v�!a?�Z[�o�ŦB�.�Y������Hס����:�n��CG�[� :l*DO��a�7�rMg��[�܇>��Ih���X��F��Q`[����$%�I��4�\vu�J]����EP�͖�Z��P��b�	�l} �u�dM"[W���6���	rO�;��y�6��� @�+�K%��D�Ꙥj�e��~�%CL����K6��i�nd�����+Nx�h��v�b�c��� �<�б�~��
"�G.j�P)�ea=���� ���R�������e 
�9� \�U導5�"̓�]֏�Hsu0�j��v�L�P ~��{(ܤ�S�B����Mk���n�2Úd{�����6A.��~d�xk��^���fK^uqձ�+�4a��4��߻<���Ŗ�/�A�}l|��۰�-��V}5Z�;-B$�E����[�d��v��|x�]M��SgFN���Zf&�>PV�5U�t���H�P>fu\�뾊�9�;x� �?�Q�#c�6q���8y���9'1,F�$��r�c�]���v��$����l(�D �n1����+��0Ts4�;rc�R~��qC���~T��S��Q�b��];����^s��u�s���7W�q��2Bl��$C�p���V2�'�'H@m�VɎ������N�d�mxV��4S��gq�D�x�*F�Y�C�;
��b�+�߲�UŎ�"]V
|<K�k4�ڵ���8�}:V�h蔫߬� d�"�&!IM2#�)!�MQ�VKi�r��K�Y����n�c�G���3�o2��|���+v��̉�cY����V����o����)*�r�Q�Xo��:���fU�1�I�R����Q,"K2N(�&�$I��pL�`Q*����BHH!k&�1%Qp��kb�O�v���sl�ȟ�٘Yv�@�M�S��{疄�\w4�8����{r���ʸk_�����Wp���m��rE���\�+ҙ�L.��*\晬4�����%���,[�J�g���s�K|I��T�}���Ⱥ��ܓ�.�]2�8�Jy�}�;�*7�t�Յ�>vϺ�
��{kGv&��t46��������vT�;mBZ�^�u�uT�`t�e���;�&�m2u�k-����0Q�:����Y��> �M��\L�[Q>/��x��"O���Y�����S4����UN�'X�)'׳V�3.��s|V|6��E�=kt&M��t��VOu?}��3�"/==��u��لGK�}cs�S�h*W�l�O�e9��+�
�螹lt濴������ۙ��v�yZLm���,�E�ؤU�$�"g�di�f��,B���%��r<�2Θ���	r#���h��2���ӣ��g����gmIӕX__$o���=":Y�����54<�Ew�n��X�[����+��]V��P��Vw�y�� �ȥ�����w����wǊ�[�q�2g�b�jb3p(�pTtz}������]/���,�K��"��/�Hw\�m��ƍ�?d���a���^��o��۬������Gz%�����o���{����-�6aCii��O��/�U���m�2>��}�}����O�=_ٴ/���_���������^��������@s�,}��J���_�o/i_��"�$k�V�(֎Deܒa����Rd��D�BE�h;�
��P3�*MLV�0!����E�_��*��C�m���%���0�7�i��k��P�#��NS��qEl��)�a�|��B�����'��?�*��T��5�A�ͥ�3rX)D��H��ȟV�e����R7BҲ>o�㧓R�ޛt*�IWK�+!,��j�:�wǨ�^����v~��U������K/_��ؐ��!�N�X�ۜ������U�����?t���H���`�{�_�t���������D���?@j��|��A�����<�}�s����^��� ��h�� �����?Im�� ���^-��~v@��/�K�_��Ԗ�'B����H�P���ޕu'�v�{~�{�Z-�p��1���8p�.&'PT�_�i����I�*@WξJY�����9���:����O��{0�	�����w���P�m�W����?��KB���C+@�
����!���U���?\����^βvc��r���v.���������?���'�3������}x����|l�3���'�J�|����m�Y8FO�].��R�ݳ�z�y���d����v�f*V���bK�*[�{����a����y�j�G��ǰ=���7Rs������'�#{�mw��2�u�|����]#N���	Ie��{��r6O����}��ݢ��{a�ʑ�GN���Fܳ�]#JI1|iZ��C$*��ʷ)�=�M{?���?�m�O��NU�Вc����l�n�A-���+C��ӂ(X � �����j�������H�*����?�p�w)��'���'������p�e��/�#��
P�m�W�~o���)��2P+��MP�"�P���uxs�ߺ������:��1����������X�q�������s]�R���xt�Ŀ/둷���A�N��<�����l(��h���p���R-�B{D�V���׌��ɞ"(Q��'��mgL���T�y)��͐�uMΞ�z�u}�k|�T���;����\�/�ȕ��K������7/?ph(s^%c�S��Jp�u\t�4�	�$�L�Km����f[Aۨ��|�:t~8sMRF�劉7j(9�����%#m�֧�a���Z�?���@����ex���.��@����_��x�^x����)��3c��>Jc�R�R(�q^����z�ﳾOЄK3>Nx>J��O�!
g�8��������/�2�?+z��8�B2h��:�dI�wwJ�<� �yg��&��k�/�����H�GO�F��ɪ}�&�md:�9���40��&��7��e;F��H�%����9L/mFT��6Ó���/�p�����P�����o������P�����P���\���_�/�:�?���W�ݐ��*7��q�D&rp�3�O9�^�v��Y8�§�0K��O�t_�Ѡ3�~��.��ݶK�92���œC��F�����*:�C�2���306dUɦ�9��E=��8�������������u������ �_���_����j�ЀU���a�����+o�?��迈���?��}[���0���ɱ|�����J��>����6�����Ϝ�<=�g  ֳ� �HU�=Z���RE�� �y og	9�U����B-��D��n����vs���,LS�����>�u��A�����I;�s�E����7�E��99�}7�^��5������3 �%�p�vB$����D��;��.�iF� ��Ǒ y,V�w�P(�H���>�f?�I[�41z�@0��&4��FX9%|�q&��pҀ�k�!*�HE��!m5���-|�1��!��3I�m���m�#2����k�fҷ�"A��:�:�x���l�k��K��ng|���0��#A���Ͽ��.Lx�e\�������P0�Q���8���������L�ڢ,�������_��?����������?a��_J��z4�z���,�n��!�.�.M�\Ƞ,͆���� \��I&�\�a���P�����/
��R�+���wXJjS��ܱp��=|4�œ���\ߎȂ�521��e��J�$����4r�%����m�=6�!�YB?���n�Gqyn����Fy�\	�<����f�8��D�tZ֮�����u��c����)���׈���%��P�����O��e��O���0�W��7Xǐ�^G ��W������t��_���k����G��	��2�f��������C3��)��Ʉ�y�2������o�wo��2�ϑ����>�����������w����p�)�q�Zp�7g��V=	�^�LK%�#�O�:^P{Z�#��:��r<bVC{6uU^m��ǔ�8�������i�`H;�|nG���,���d��r�����D�;ƹ���q�������ަk3���ߡb��b�KuH�=�OeG�&ۢb�d�4"��ֳ�!ɺG���|�4I�Bs3��w�f�D&���Z��ȩ++��1�����E�Hr�1��!_���P�wQ{p�oE(G����u��_[�Ձ�q���׊P.�� x�P�����7M@�_)��o����o����?����U@-����u���W�����Kp�Z���	��2 ��������[m����7
��|����]h���e\����$��������}�O ��������?���?����W����!*�?����=�� �_
j��Q!����+����/0�Q
���Q6���� !��@��?@�ÿz��P�����0�Qj��`3�B@����_-����� �/	5�X� u���?���P
 �� ������"�������j��������(����?���P
 �� ������?�,5�Y��U���k�Z���{��翗�Z�?����:��0�_`���a��_]��j�����Wj����9�'���
 ����u���{�(u���Aڛ�>�(;c�p��s$N�����E}�D}c��0�u9�$)��g��_ԁ�	���"����ѥ��*Oo��s�8��@�6��Wo�0"U�^OP����K�F�>?BMl���ju\���/�����!��<?��̰�a��ˢ�L��kq�4�0B���>C�L�V!e�:x;���xc'����!��|S��Ա�p
�<����ݓ����p�����P�����o������P�����P���\���_�/�:�?���W��ШSc߷�Vc��Ⱦћ�bg1�a��/[��?�q_�?+\�̓�ҋ&�oX�n7W�xu���d�"�!u�(<a���m�Ӄ���b>MOm~;�jҠO�i3�QBU�v��eJ��ｨ�����w�KB�������_��0��_���`���`�����?��@-����������xK����������MF�8w�Ɯ���
�Q������j������N�ic��|���d�i��-S�o6���Ҥٙ�^�v0	$o;��N�CS=b�^4��aF�U�z�Ş�ΈL��q/�S� �}��3���Ƚ�G/��5���҉���n	�&\�;!�[���/xysY���|�E�PoG��X��uC�XG
�"��O��L'm5�_�yM6D�Ü<{�I���c�d�1({�y!�S����Ák�{KG�cAN�p=7Q� Z������$J;��Ĳ9ۤ�5����
�$�'� ܽ���?��E����3�������?��/u��0�A�'������?%���WmQ���q�'Q��/u�����$�(���s=!ӣ~(���1��y���(N��W���tK���=�Cӏk#�Lb�a���.��u�rO���-�7o�"��Y���g�M���[�t�|����?Y~�G���Y~�w�������_[��&D7�rx�.���5��sl���-!�_�VE��j��_���0쑯�i#�W�@F���en'��e*�?���1L%��a����9s�7)a��tze��h�&V{8�[�w	����?�h�'+��}s��v��rYs!��ׯy��l?�雭�CF���O�@��X��M�-������f�܈��fǠ�?��Y��ֱ^�̑��%A�c��b����R�w:`T0��O&�i���©K�F�DBl7]!7OS�஽\���(PGnJ��l9�?�̾��˿��wC-�u7��ߒP��c<
�h�p=f�b$�r3�����$�s3��Q���|�$��K0�S>z憨����Y�C�?��0�W
~���DG3���� �V��N������]��ɣ�2�#�/���r��j��\����/>��5?���0��2P��1Ľ��������(��������4�R���+������S��oe�0�g]f�:��w��k����y�e�NΩ'��j�!��������������o�	�����|��퇼��3�xov��Z�@�t�!����0���pkL�Qśv�8�:�i^\{����|rH>cg�b�nu�XI����|����~�����b|3�y{�n�����v���t��-3��ye�,xy����$</���Ys{�a�Nr9�_J�������v�#��j^���!Ͱ�\؄sr6��7V]��+��l��
3_����u������-%��)��I?�YC���׎�O_���0�y�b.���o��.X��]�.�`,G����(�����G<}�A�}>~�����봍�Z�r;����8y��Ɖf;T����'Z�;������Z�����ދ���_~?��1
�_������{����+e|����/��XK ��W����UJ���h�e��?�л�����/o��k�����Gc�m*��6�C�'��~��������?ؚ���z��}l��v���[�H '�%�4=���K˳�J.�)ϏI��G�w�\!m]�:W��ѕ~�������sR�����ܜԩs���Cz��V*�����[9��� uj��mw҉Τ3�f3q}���D��w���ZkW���>^���Jxa/�<���i9�Bg\�D{[[w:�T��hV�n�l=����}s|��*&��h�6�2�rڶ�t��H�1k	\�m����J	/Sh
�y���y�G�)q�<��n�x�=���gw;�b�ꇽ��v~��6lIi6F�í2�%Ym^���'�u����vcR��ld���j0��U���UL,ZJ�Ѷ�f�~���#ؕS�벵��R��p�qT��J%)�H]�+����|ß&�um�o��Ʉ,�C�?�����_��BG�����#��e�'_���L��O����O������ު���!�\��m�y���GG����rF.����o����&@�7���ߠ����-����_���-������gH���!��_�������_��C��@�A������_��T�����v ������E����(��B�����3W��@�� '�u!���_����� �����]ra��W�!�#P�����o��˅�/�?@�GF�A�!#���/�?$��2�?@��� �`�쿬�?����o��˅���?2r��P���/�?$���� ������h�������L@i�����������\�?s���eB>���Q�����������K.�?���D���V�1������߶���/R�?�������)�$�?g5���<7׭2m2��ͭb�5M�dR�����d˘d��ɱ÷�uz��E������lx��wz�(q��Fu����u��
M�)�ǭ�o2��wY��^�պ(����t�6ǝ6&w�Ɋ~HS,��8�m��/k��Ȏ�d�)-zB:]=h�V�E�Gu:,�q;,����m����d�U��\OS���՛�nǮU#�rEy�'����$YG���Wd�W�����E�n𜑇���U��a�7���y���AJ�?�}��n��%��:~��'jv��w�^���b�Q�ˆ��m��m��E��Ξ����Fu�j�[��j���#��͆�6,E�D8��~],���ߪb۰�sUk��ɫ�v��]mN���&�P;z��%�����7�{#��/D.� ����_���_0���������.��������_����n�QP�C��zVa��U���?��W��p���)VĚ8�)__�_ف����6��h�@*���z�.K�l�?���E��5}4o����D�0.L�x\��!iͱS��ˉI�U'�N��z�����~Q�j�J)l�[m,���m
��:;���_e�*��і����D�Z�F�1M!��bwXO����h�IJ�}v~s��V�~������^�|Jb���*P���r��KQ]٨5�V���v9X��ͦ2⇃8?LKQUZ�X�8���N�Y2D{�����qqېI�]?hB����|/Ƀ�G�P�	o��?� �9%���[�����Y������Y���?�xY������������Y������&��n�����SW�`�'����E�Q��-���\��+���	y���=Y����L�?��x{��#�����K.�?���/������ ���m���X���X�	������_
�?2���4�C����D�}{:bG[U�7��q������0�Z�)�#fs?��
����s?���L�G����"�w��Ϲ�������uy�ݢ��]�D�����8�P�;fm���\����j�7��O�gCvfNcap���M#��8:�!,Y��dSSmG��Q����Ѽ��_�Jޯ�WOG���\�F��4��
�}8V�����tu���_����Ug"��`1�lF90'<���%ik��Nt��jX#9jSo�}2�V,�X���`�fa�w��ReCi��DpT���vra���?2��/G�����m��B�a�y��Ǘ0
�)�������`�?������_P������"���G�7	���m��B�Y�9��+{� �[������-��RI��_�T�c�Q_D��q��Hmك�d�S����>�ǲ�<<�����،��i
���=��)������0��ыFI�h���z~��T�i��,u��7CS��W�*G}���hA�F�P/rq{+��eY!F�o� `i�����$�����B�{�X�/t)E�W��|aʜ�b�-?
�¢��nkO�����lX޴��P�G&��^S:K�X�!m�WЭ	�m�������?L.�?���/P�+���G��	���m��A��ԕ��E��,ȏ�3e�7�"oY�fh�f΋�N[,�s�N��E�d�l��a�OZk�:ϙ�O�9�c�V���L�������?r��?�������O�H&O��Q�Q�Nf��j�j�4*���<�ބ&{�`��Vb�埈`g��kL^�J���������ʝJ]X��5rr�4׉Y<�ZV p�|��n4��?_K���������q�������\�?�� ��?-������&Ƀ����������z�X�􎬊Ĝ�*Ċ��K���[Q�Ew��/�N��>�\_:���`K��_a;�YRL=4�,�G�~u�N�����[�iW||Ռڲn0.O������&^����24��%��E��3��g����``��"���_���_���?`���y��X��"�e��S�ϖ>�����ct�\���t/B�����S�����X �������wں�E[M�$������q��tc����r�J̧2�"��rV�#��'�`�)��Byh�X��a���שҬ�ڶ��RW�/�<,��DM���';O|�V�OE�;�q:&�BwX��u� v-a��$:9�6�RIv��������my�(�+�*"c���=QJ��S�M��MԵ�_�S��i�򳽈}U8P��Hԫ+��u��ˆď䓻p��J��ڞ[���b�n�0Fb��*4��Â�S�}�1�Յި���|8ezTqZ&�r�w��#O�9��}tx]���'����B�i&��?�ݹm�x������:��_v��Gm�(�����	bO�>J5�cG�?��+�y����<�Y���t�Ϧ��|L������]$�=c��������{=���G�����CI�������5�L�X���R��7?�%�����?}J����p�}���?�㾊��i>�����������.0�ox��D����n���Ǎpm�N������{,4#���'縉�i$����I_�zR��v��I�d���r��x�0qcfr��${{��(����7�x�#����w��~�c�=�I��%���w�����w܏�ɫ���[~I��OO;v������<Q�T ���;�r��}u��������<��XK����~��`m�m3�Ϗy��ӕ�渆�޳�M��"�`纎k��DނO��?q'w&�� �Bo�q�4����ÿ�Z�~����f�?�i,<��/���צ�������{��$�|��9��f@�{�M�t����?n�q��W��œ,���67aF���x�s�pM�ӓU=���SJZ��E�qwɍ'�{Տ�j�����H�VM�;���Hva*�����t�w�j�ez�w�ח������=q�}                           p����� � 