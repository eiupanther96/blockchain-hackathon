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
� =��Y �=�r�Hv��d3A�IJ��&��;ckl� 	�����*Z"%^$Y���&�$!�hR��[�����7�y�w���^ċdI�̘�A"�O�έ�U���Pp��-���0�c��~[t? ��$�?��)D$!�H��1!!����# �S���lh��6aW���-{�+�.2-��Y��Y��j
��9 �'�m�~3l���`�6�����Z6HY��A���2C��c,�P;ش-�$ �lK���g�]��F�)uP8<�d�R�l>�~� p���+�T-~��,����UhC�2�aySB�ė�2�"�	��"d�j[3��ab]�� �D6�X<�U2�E�H%��4��ݤ1Մ��tw.���O�i�7��d�M\�t�x�oښz�LMY4|Y��ulwA����,��bPXD�&U�ֺ�"��C�bc�ᇚ��|6}�&���UԠn-lWk#��e��<l��$,�t��ϨO�1u����Q�C!�r]�vGGt�q!*�_v
��L�`��V���D��j[�|��90b�r�WY,��Ӷ;d�
bBwz��2����n�l0�tO�k�������2S��̑.bw�&�f�)��'���ʘ�m���kx��g ����+*�CG�����i@}hK&m����V�󁫁*���'|��6���G��|�O�x�D�<�{�������o#�F���נռkl����_���G#R8,J�\�K����_<�.TӌPZM�� �?}��S5�jL��*)Wv?T�ʩ�[����<��{���S胎!q6�|����3��>]��*�bx-������0C�;Pi�
�[ظ�6���4��O�)�������n:��uf`ȱ1^
��[:}4��2A��Y�ƀά�ـ:6�^��tܡ�b���l�qL�3���Zڴk�� Vd"�\����O���f{�� �lhɓ�S�����3Jc�
����)�c7�9}��j���5k[&R�D��wE�ȎT���������Xi)M����:���{o�;� �aEc�W~�ٷF�Ps4]@Sij]��7���ˁ���!Z@�{4Z���� ����H0�'��@�Rs�A�?�s����$���Av5�k���`��O��4{;tWp��&O'�Xi��W���P/����	m��t@C&j�."���ahFc�R���J��;�7�+�;w�>W��79��Ro�P$�w;����W��ATR��{�=J�f����}�G"���X?e����Ó�����s[/�A��I�f0� P���,f�	���ޒY Z��	�\6g��N{�?L����uX�=�K K�1�+�cc���s�����,�Nydh7y��`o�����ل�ͯ���>�9��v�>�X�:�G.Bȕ�f�h�UL>��&�(�;�Dv�CA�H�A��)M��g~<�~�v�3��6و�f��7�<m���<B}h]6��۟�����F�6����G��l2qz@�D����q�eѝ�W�+��<t��^9��©�@k����O���~(���'�k��
X��|�0C�GkyOm,�Q
ǧ�_\���\?)=:�q�3�l���OO�v��;fb�稷�3a�u�Ӥ�� �6�\:_��u�Uw��T9X����&�U��=Ϯ���=�C<�]b�r��x�Y9YΧ>gʕ�A���`�6{N��,��_'�rڴ7l��_��50Yaǋ*�n��4	E�x�t��,ݩ\�o�*����B��:��h��.F�s��R��kC���#F�1P��D;���V$޿xʢ�H�o߂�3��3xj"��=�$̹���mP$�8�Ӯ!�?~~��R ҺtN�tzB'�i%LF�o��<����i� (�$�_�����s��p'�E���������X�_6���AӾ��2���´�����
���|����贁f��utLT�.�Ў�~=˾�:w��?�/ݽ�e������}��X��l�s'.����7���_	�t�����G�G��?����J`��o��±A��ed��|	:�f���v���<����#���ba'��c"N.�vw~v���^|J��c"B��tl���Ѿ�`�'V߲Q� #�{֐�D�Y��ҿޫ��X�O��˱�gҙ!�.�����Աu$e#����<~�̿UG\!�	���ŞBݘ	�0��.R����ke�0�:x�3��{g�wJ����i0p(:�����-�M��]����4}��P�o����A�|�Zs�Z���BDl�pu)d�3�R��W��a8�=�q<����@@
Aq�o�� �{�
���[�����&�,^����]���T�M�8Y��J�����d��m�ѴA����~�Ox=4���v�n*�wy)�4�76-�R<���]	�U���?w�����B��)���l H3���瀌��e ��-�]�̣�)�
�"��V�a���� �����i}�P!����,��6z�.zqSwiƳ��LQr�^���l?�Ė�&�AxIC���):&�H�K0��gi&/�ČS��ffΘh}:YƬ��raLu*��ӫ݃Bf�0����)�r����#��s���%3��Ґ�@Z�"��H�?+�wc���1��G�������>��۟���>�_�z�GJ�UOA�bYt�������hTZ������������o��������_��0e~�	Ej�"I��V]QJ�z�.)[�D�^K��p"IDRLJ�I�R"�H���V4\ۊF7��k�/_sӄ7���N�tt��/���6�������G�>�6,lښ�����6�lT��}��&���W�|5�����Y�;k�_6����mp���H��~"8sb�ͫim�a�1A�[�`��h���W0�������w����<�[�q{���5���率�IK����K1!�����+o�5�@�n54���;�aRz��%�d��A7�O�^Om:Y�o_�֠�ly���E%k��juA�oE���V����$�p��m�PP"��@q+51aJR4N��|jW���Z�S+@������E�ʔ��l>%W3���Q��S��TJVR��Oʍ|Y.:�q�E_%s}�&��LK/�R���>�_���S.3�������Q&�,����K��l�	�j�Ul�rz�y����E�\>r�)��1y�%s���uN���ix�"W�߸���%�g���M�Y{���*��ZX��M���)T3�b�ߞ���m*�BU����B5/T��Zv�ʄa�;��<Y+��^�t�>.�r�����L�@&��.�,��Y��u�v�sZ͜�%w���;�(�u���I��)��.3�BR`r�wR:)��$*��0
���rY[�]���b�VM���Lr���\� %�F&�Jy�{�]Y��ɜ��w�,���E�Z8���x�v�wr�ci2'���䮱�:9����)ܓ��P�hZ�?��uz�b%��
�a9v&e��Fo�ZM�d��魚�e��^���n#-�\�I�����e�����|��*���|�m�A'��'�������?v�D����R�XA���.w
2�GFV0%��9J�K)��+���L�c�z��-x���$BM��E<����qr�;NtSj��oT�{1�.��8�3���
��Syg�9.�BA매D������;��|���!�`0��������׌��1��l��AtsC��� �1!��?P&`��M��Ex˞�J���]uw�����c_Ê���?2��'"��u��J`�O:,珉q {�SV��+�s��&ˋlt2'� ��J�� �{���=��Z�{̝��BE|���]���4R.�{%#�4�˕���MY��b�S8j]fa*���Xj�t����9�u�/���hVGѣ��pNk��'��N� ��P�C�#���ޭ
����&.�s��>��=��e�������*��������G���e���?W���(��O���l����z�)����咒.5����L6}��ׅ����D��с���cdϲ�V)N��s�-'����#����.m�n�aOܷ�ޅ����j����θ���瞵�|���;6��%u����J���]���J�����' �;}��E�������L�,PF�/� ��FY���ݴ��,��!s���<��? ��7��lX<�4�k��"�p�FuAC�d�hC6h�/j	Xe^�Kc��?-s��)=��� E�#8� H�6Ԍm0_���mJ��t��V�����,��q�� QU�#����֕я��b�v!���g��xo��4��AXxؓ��߆����ȏ8w:<�����4Ȗ���M����$�X�ݫ���;h6���1���4���cz�\C혌�� �?^h���؃˥D�@��6z�J�K��ÆM/ B@ӄ}� -$��MY�v�؀QY��mi�K��a@L��z��dJ� x^F�l/6A�ɤ�~a��(/����J=8F'E�.o<?`*ꛬ/�@��lox4��?���<��"�z|��@릊d|�����^���Mޞ����_]�����Ƀ������F�5����v���M�f��c�I�KRs(��|	Ldu(�u��>k�i��կcLʴ��(z�dN̯;��'��8Ŏ�c���Z~SzL�R�Ȳ����٥4�_>�rJ��������^���h���<U�.�@�u"l�0j���=���/��R�c�"�r��M��ZU<)�v@��)v�������G{�,!x�*m�t�v�|E,󵡢�B�oz�a�����'�R�d��b����<��fpB��H��ٵCW҉�I�ێ��	!JE��H��q�	F����G�S�n&k�:l4LԠ���1�\Cq�D��UH�P���4�뼂u]�?�a=�T'tp�m����J7��m�F"C��!K�3��y�L����⃉ӑ�r�?}o�Jm+��B�Y���PU��}���bl�Gl�S�d���dmُ�,lc��_�"���?���]K��XZ��i����)R�
f�L7�K����2%�;�s�<�'�+'v'���N�d��B���@Po���Y��alF Do���s�����B���[���}��9��������<~%��~�g�?��.�ŷ'E���?W������o���~G>Ǒ���������譣C�����5t1�ʟ~�Bѐ�H��*�X�
G�r�)IaM<#íA*dT�	�lK�!��_H�x���~��|���~��W~������䏞��8�{�],�;X��G�^�h��_����� ���z/��� ����?"_J���=|�0�O��v�m��{��n��b�S.Z�����n4Z>6�t,��z�l2,}�t:��~/�/X��,�
�-��W!>tUC`Zv�P؍��Z3�XsA��ٝ�V&6�.iB���B�@
��d=[��
�3DH	���N���HkQ(
&g���1[��ǍAl�h]�X74|��L\�����ns����L(�̈́	3�rs�k�T��*n6��i��B�4���E�y�W/��3^����3l��׏��iz���y͠:� S<���S|id�|�k��t"�.T���~�.�쬄��3%Y,SVF�+e�B3Y��"��)�����$����5?]O"L�A��	3�v�I�ْC�Y!��B')�yD�:)��"}.��F�4��05+��"S����yx���*�4߉/&=T+��.q�@汨F.��L��w��.����43���dMk�IJ�UKe�H'�Qz6nRbnn�'��X9�����������^�Mw�^"w�^"wE^"w^"w�]"w�]"wE]"w]"w�\"w�\"wE\"� ��0�.�f)E���O�J�Õ�Rb��9��7��x1���8��60�.��q/jgE�s�*'�K螻�<R�[��۩����@���������A\�S붗yj:Ċ�Hz�3D渁gC�iT�r���f	~����ܔ	�jiZ=G0��S�DY
7��&��	N���Hj��j�����&�'����8c+s�ٲ�#t-��Itoi⭈�Sf�[87/T?:5�r82�1J�a�C�9�)�fbX�vb��(N��<]�D��eS}BᒹӊJ��ܤ�Gd��J�~�̢Ԁ��˼[�w��ہ_8z=�A�(���G�=z��r�?� ���u���n�}���o���&���G��Z>	�s������G�N>��^�:5]���/z�����x#�ׁ�����[�(������+�o<��c>��������<��+EYfi�2YZ�|ވ�r��2y���r�b��ۭ-�/�/Z�'X����8���-3a�3I��Pr!���Ky������\�-�
&�qD�ilJ����]	���o� �D����tZ�������x�BH5J����Ȕ�S�cv�W������T��ln���z�X`��z�mQt|�TZ�8i�F�֣��6H�;*?NWFx�Dj"���L�x����+�4k9M�S���4K��� #�@��P!iAf;��3R�[T�F;*]n'���HĐ��sK�l=Qu�4_�/�SdMQv�)�e8Z�՚���k�&.v˃A�D�	�k9˂�`d-�~�l!���9m�����]f�tÚrܘ3U���-^�J�d�G����ǿu%�ā����B=��|yP�����δ[\n�����e��]���4�K���� �u�#�q��"��"��Y���j#�o?c�gf��e\vGn��.�#����u�{����7�ڴ���
G�[�e:��Ɇ�Vyc֑�|&Oԓ�8�Vla8,)�zܯ���X�.}6�0Ōb4��í��y���è���F��J��lV��*\�ڴe�6��M��6���x��Gt�:��Sȇ�N"5�u���8R힟Z{:��A�|�W:�dZ�R�%��b��҂4=mբy%٨(�T�/��1�.Efi�	�ys �7.5/E�a:��&S�v?�Ry.B�[Åip�X�1#�x�E��³��y%OdE�H+E"dg��xXS#S�1�+��-��l��U$#3I;�d�p�G����4�2An{�*de_�L$k;�*�"0�]�����W+�Rz*�+����X��R�C��Vp�	���c.���*�5
%�Cp�cq�K+ճ(�<Ki���M��et:S��;�
q5��)g��y�)�����E}h:��*��=����	җ�BJܐ��Ba�nF-E�N���|��r�J7D�V����l��5�T�Q���a2j��4�cSi�4���%��P6�-�F�U��r���.c&�.���_|˲���w��M7��ٍ�/Z���.�����<tlѢ���*8r3>�e�g�i�2ԧ��+����7��6�<F~���V��.��{����ϟ?�?|�<�����#ڎ���D� V�>E�΀oISeۇ�]�@\ӛĕ^)�y�y��t���:#��� ���#2�q>A~����)P��8�8uG�k��{�y䁳8�,O]W� x�|�`���ҡG��"�2+G�k��t�t�� Od̯����������H/���G/8���A����ד ���
�;��ts�����T�
�/�Vf��z�;�0V%���4���Ŏܸ��;
���4���3"�_���926ifw��]���H���I�S�k�*��9?�t�l�㧫���3�z�폭�U^Ѣת����U�ɎN��h���s�cj|oo==VG_Q�lH��z?<�HPP� !=����%-�8F�G10E�6��'
,Բ� z& 1�"v*�2H}c�]\ �3�w�ؤaв�S�� �fq.���Ի��&������ �˩O��/O��jNW@���+��V��&>$�MO��`������z�_ g�ADVТ3��1���X뭭u�v �w�W���h~�ʬ��A�|��,] R�̢�'���g�*�L�*�?Yu�b[�h���%���q��{��юW�]�Ip��:�z�"�gm�}��e�tb���2z��$��6�O�aKK�I�8�j8���jQ;�+��@��z!�g䊉+�������ԃ��?�0Ӱ�M���	�����* �.6��u��~�_�/�LF�}=w�_�1t[=:�� ��`S!z,-{�Q�k28� ނ��>�)OB�P��Zm6����6o(�� )�O◧q���粫k@W�g/"��B�m��p~в���dM`e�%�s%k�hٺ2�^���-%O�{��Q�� 8\�a�n]\*��/ ���P�$U�/cX%m �cp.�bz��v_�a�Nv �ݶ��^q�Eo���#�c��� �	����ӔT�=rQ�@�J�&(�񟅜	}�vp��,�]� _�.� Q�6����*�u�ii�~��@����`WV�ce2����C�&͝�\2�o�nZ�<�t;h�Y�$�s�>�n�	r�#��[�E ���D�4kX򪋫�=]�8�	�e��X4(0����.�lto�x����c��� �ކ�8m1���j�i"�-B���W�Z%kݶ�����jBH��:3r
����23��z�:��:�k�'ش_@���1���^�U�͉�	�C��	�z?붉�ֆ�Ɖ�S�9�a1b%)��������_��$�-4egCi�@'(�w���w\qpl��b��Iߑ���j�����
$��܏:�����������������m�����+���b3�'�`��}$��!>!>A@j˶Jv�ܰe%�vr��h �oó�g���"?��g 2�3T1Z�����Q��+\����*vt��R��Y��\��ծu��'���ӱrEC�\�f�H!K�I5	Ij���HdH	�m�j�ZJ�#m\��f��?F��v���p8�H%��}[�����DX�ì�gN,�*�����l�Ƕx�O�'O�Pa̐k�bǂxf��W7��IM����&�bY�qB	�0)&IE�cJ�RQ%$5eBB
Y3�)ሂK��X|Ҵ�����c3�D���̲��o���7�;�$�亣q��	Ovfߓ�E�V�]����wd��cw���msE�+ZT��\�Μer�W�2�d�9�\��/�\�f�"W*=àu�]��[�K'�r�3x�E�����_pa�A��P���3���U�A���.��{��U@@�[;�3�Π���vF�\�'-���i���Z�3��b��-��o�A�6io��;]k�nxl熉Bw�!���V7g�j}��nz��0�b�ߊ�y!��sEy��&��W� t�>���l<Ǯr�<�rL9���"�qY6����P���(
�Y�3i�N�CǶz������Yy��?��m�&<Z�����ZES���e|�,ˉ�\�T�F��e�3����F�X�>���d=�k��bj�g@�=fY-�&��%�9�'K�4C��gq�e.�ϕ�)�q����N�1��E�/�A=�-�O�8��L>kK��\����"�xc0��EL���:Mݝﯡ���,���vs��:߲]��d�X��`��2V��~��0���{�F.u���N���ͮ��;V�ߊw�#�9+3V���@!t����3��m����zq`�&�f�_�$9��G���o��6n��!�|'뿏���KF�f�CD?��>�+���ķ�c���H/��MoI�	zH{H�X�[�*t��{I���'plS����A��#�K�ß��i�ʦ}��K������_ �����hhh^���f��W��#w��:�{I���9&Y����E�v$*����l�Ȗ"K�X$��*�EۡV�����pTib���	�u��,��j�Wa���m���k/�g�m�ɼq�O�}\S��:iet�:G�+b�M	�;�4��u%?��8ɍ��$P=��E��"m.U���rH!2��@��E��-�=�ޖ�����y�?����ޤS)N�Z*^	a1eV��a�;F5��؟�����O���?���_z���Ɔ��8iw����������H���'�������Gڗ�� x���ʧ��?�����[�d$r���H�,�R����+��� ��]��������
�x ��D�O����.�Ij[�S����j��G�Jti_��2�g����?:|��G:��<��<���?���;Q����+�{�j���w��IEE���w1�8�����O�X��N*U�r�U�J%��f�}��Ͽz��P��=�����RP��P�W�������Sw���%�F�����?�����[
ު��k����J]�?gY��_u�NHe;��?�J�?}MHn���u������c���>��y]�D>������Y%D>}l����,����.�YC)��YX����kf�C�sk;M3+��\��t���=��w���Xzȼh����m�c����������m����϶�_m�L�:�^>X��ݮ�K�󄤏�2Iν�f9��[�o�>��n�\ً�0u�H�#'�]QE#��������4-��!��d���Ǧ����S�����r�*ihɈ1��Qf67Ӡ�������iA,�j ��������W�z�?�D��Z���p8��@��?A��?U[�?�8�2P�����W�������?�7������?�&(�?u��a��:�9�o]��{�o�p�O����U�X��N�߸���~u����)�sg<:k�ߗ��[����c�LC�z�I�V�x6WZ����v�VLw�k�=�K+N��kFm�dO�(�Ă��Ͷ3�gd*����fH�&gOe=�׺>�5>���� Q��\}.��h�J���������m㛗84�9��1�)pD%8�:.�K߄Rn��6ev�Nz���m��c�o�:?��&)#�r�D�5�Yg�g�⒑6Z�S�0�E-��@�a���@��2<g�dB�_�������O�z/<�A��ԉ����1������b)�d)��8/DC�c=��Y�'h¥'<%|ڧ����3~u��G��P���_���=G]�b!4[M�F�$c���;�k�kǼ�hi�m�ŗ��ess$��'�#��d�>���62����rrG���B��#EY$ǒd���&��6#*j���Iq����u��C�gu����_A׷R����_u����Oe��?��?.e`�/�D����+뿃n��A���8b"98�ͧm/{;��,g�Sf�%�[�'��/��hЌW?gt�K�n�%����f���!�e���Џ�d���y��١a��uN�?2��d��
�����ߊP�������~���߀:���Wu��/����/����_��h�*P��0w���A������S\�_D��D�-�nxXO��I��X>M����E%�����[�a�\���g� @���3 �?�هg \������P�"�C �<�7����*�l��	��_�Kg7C�VSP���km�)�b��H�z�:���Pz����x�9�ތ݂����"r��まG/O����|�� ��rM��;!�[�E|"���q��4�h���H�<+��n(k$RXV��	��餭f�=o �\bk#����?�Ը���o�?i��5�y����lp��ИNՎ�ә��6HB϶��f�~���E�5C3�[g����~�hr��jc6�N��5���U�3�ދu��@���������}&<�2��[�?�~��b(��(u�}�����RP
�C�_mQ��`����/������������j�0�����?�s=�r=�CIe7���Q�s]��I.dP�fC����i.��˅$b.톰��i�C��h���O)���N�;,%���z�X8B�>��I�sr�oGdA��T�2�k%o�F��l��В��v�ö��٬	����|7飸<7���yD��M�G���CG�m��w"G:-k�G�u�ߋ:��1���?�������k�C���w(�����	��2P������+	���c�x�#��������U����P:���/���5AY������_x3�������������s���d�ĉ�\w��~Q���Ļ��o�����~_C~f����F�q�;���x�w���S-8ț�����k/O����ޑ�'�T/�=-͑���
�Mo91��=��*�����cJc�Is��MFɴ`0�R>��\]X���x��\{��s����v"����z�FP�{�\]oӵ�����P�Ek1ޥ:��#^�mQ1D2S�h�YӐd݂��\s�q��P�����;�A3R"�R�d�w�A�J�ԕ�\㘃�LFZg��Y$9������Xvi�����=8��"����|����������8F@�kE(��a�n�C��`��& ����7���7�C������*�����k�:�?���C����%� uA-����	���_����_������`��W>��Ȯ?���	x�2��G���RP��Q���'���@Y��x�nU���z���B������r�����/5���������?�����(���(e����?���P
 �� ��_=��S������_��(	5��R!�������O�� ����?��T�:����H�(�� ��� ����W���p�
��������W�z�?�C��Z���H�(�� ��� ������?���,�`��*@����_-�����W����KA����KG����0���0���.�
�������+5����]����k�:�?�� �?��:�?�]Ġ����P�a	���\8�I��9'�I�l�>A������y㺜K������/����A�_�T����R�G�����ݹT��?U�B�ݫ7`�*y�'�I���G#N��&6	��x�:�ZR�C�������E��bf��0��e�rE�Q�ȵ�J^!�hi��!u�Z���G�G�|����`��w}�)هsO�Xh�m�h�����IU���u��C�gu����_A׷R����_u����Oe��?��?.e`�/�D����+뿁Ohԩ��[y��QSd���B��Ű}��-lpڟ�T޸/��.���\�E��7,|��+A�:H�l2G���J��SK�6��A�v�v1���6�l5i�'��(�*i�Y�2�C��^���w�;��%�����������u������ �_���_����j�ЀU����a�����|����O��o�O�&#B�;zcN�lqd��(~s���~��{�vWi'	�റ�[>ց�{2���g�7�q�mi��LS/B;����J'����v/��0#Ǫ?�����b�mgD����)Y�þ���Nr�^ۍ��W����t�����a��\.�-�������,��]�ӌ�A���#A�X��ﺡP�#�e}�'�~�����/��&��aN���$m~�1o2����<����wrf���5ڽ���'�m���(X-W�F��x��	�[bٜmR����}w~���]�^�^�������R�����?~�������:�� ���K�g���`ī�(���8��(� ���:�?�b��_�����Ϲ���Q?����������H���+o��%�|p�����ǵ�n&1s�0N�s���:p�'�����ě���,M����&]~ԭW�B>z��Ο,?��~�,?��g�r�������KW��u9�Z�W��Z��9�dl��/N�"|w]5AȯufwC��WŴ��+s #J]��2����2�Ō��q����rѰR�]�9՛���a:���d4o��=c�-�c����[�쓕�侹�[;wu���M��׼�n������!���ħ�D EF,�c��֖h�vS�n��MnD�c�cP�E��|i�,]R�X�\�H�� ��{��
XDv)�;0*�y��'�4��k�\�T�%f#R"!������)zp�^�	�io�#7%ru��sf_Z��������������oI(G�1�z4F�3c1w��c��a���J�(N�f>C��%��)=sC�����,ԡ������?��+�r�_���q�e{+Ed'�MG�`�.a���J�����{��g��|D�\�
�����������P	�_�����^���W
J����Wc�q�������?�_)x���W�����){�ط�X�.3�	��;�ϵ������2P'�ԓ�w5ؐ�y�o�~��xW�y��7�����o����C���D�7;�P`�s�E�ې�A�ZG��Q�5��ר�M;�x��X��4/�����v�?9$���q1Y��Q������C>���l?���zr���ż=k7�Q�a�n;��Jt:KӖ��Ǽ2]��<���x���I�ì��^�0�
'���/%J�R^���K;���S5��J�̐fXs.l�9�
�q�+�.��me6wg��/��:�?����������K���,��Č��k�ϧ/_QL�<�r1�uY��7�E,F�.�Q�G0�#���D�q���#�>���>���ku�u��B�E����BN�<Wj�D�*�}_�-������{�rU-�Ge���g��������A�]�޽�CA���2>��u�Nx�%���������%��s��j�����?�]���P�����?�5���v��1�6�^ڡד�^?���}�C���lMPn����>�
~t;�QZ��[��A$�ɒ	M����|֥�Y_%�ǔ�Ǥo�壅ܻu�����n�+����?}��i�������ض����N�[�n��S'�
Pl�oo��� ��S�_h��Nt&��4���S��� ��{���Z�����]W~]	/�e���Z<-�Q�k�hok��C����`��*]�훭��;ݡo�O�U���ރ���fV�XN�v����i�"f-��O��V�^)�e
M!>��X=��(5!n��}��ԍO�ǛC���n�Q�Z����֮��ۆ-)M��hq�UF�$�͋R]�䀽���ڮaLJS��L�>^�s�������EK�7�v֬���@p�2`Jr]�VR�Q��`�1����Z�$E���z%��3�o����������?��E�oh�����o��˃���O��R�!4������䋐��	�	��	�0���[���9�0�K���m�/�����X��\�ȅ�Q�-�������ߠ�����`��E�^��U�E�����	�6�B�����P�3#������r�?�?z���㿙�J��qA���������������2��C]����#����/��D��."�������P�!������K.�?���/�dJ��B���m�����E���Ȉ<�?d��#��E��D���C&@��� ����������u!���m�����GFN��B "��E��D�a�?�����P������0��	(��б!�1��߶���g�����Lȇ�C�?*r��C�?2 ���!��vɅ�Gr0������<��������۶���E�����2"�op4E��^��f����U�Mư��U,��ɗL�`8ò���la�,�|�#9�c�V��OO���]����/��NO%nިN���.�U�)6e��M���.K���Ze2�ұ�n�����N�"Yяi����m�A�e�B;b��ўl7�EOH��M�j�h��N�� n�����ڡ�P�̹֒ʐ{��i��_�zs��صj�Q�(�������`�$�4ڃ�����߻�(��3���C�Ot����5���<�����#��?�@����O�@ԭp��A���CǏ��D�n�����cb"�X�7
q�0�qܲ���-񻨶������ר�V�y�=Xmt#�z䶶�P������G8گ���~��[��Al�p�jb�]#y5�.ձ����ăj�BO����/��/"P���vo?c����E��!� �� ����C4�6 Bra��܅��� �/�Y����k���-;
j~h{Z�*��*�y����j�n�}>ŊXg2��+�+;P�}=؆�mHE�^o�eI�m�g�q��������mݝ��Hƅ��[>$�9v*x~91ɼ�d�i�Z��6���/j]mW)��C�a���^�M�9[g�p����a^E�?�r�a��5فhWkbר<�)�SQ����^m��9�@��/��onVՊ�د��^�|��OIl���TJ8�Z�6p)�+���*��.��T�B�p�i)�J�R+aBr]|��7KC�h�]�8.n2���M�~z��%y��(�?����� �#�d��k����A!�#r�����/�?2���/k�A������O��?˳��Y�T��$0�p����#��J���dr��8궸E@�A���?s%��3!O�U �'+��������o����P��vɅ�G]��/���$R���m�/��? #7��?"!�?w��KA�G&|3���h��?���oBG��c���&��2.�?�A��F\�>���c�G�X������c�G�a؟��HS?�W��N���9������<���.�[t�~�+��Z��q�*~Ǭ-�X��0�}c^�P���T�i��l���i,N�6�i��G�#�%k|�lj��(�:J�~�?������]�����i�a;�ВҨ��&{[A��ʴ��cA��NB���+8��Ld�,��͈"�gV��$mm�Չn�Yck$Gm���O�݊E�5��,����XY�a(�u��
�X�΀A.�?��Gr���"��������\�?��##O���F2%����_��g����_P�������Ar���"ਛ�&�����\�?K��#"G�e xkr��C�?2���W*i������v�5�H8�\�-{М���������X���'Z{c�[���9M��r ��_>� ���V���64z�()� 8�S�Y�o���6mћ���fH`J��JT�O�ޢY-ڨ�E.no���,+�È�� ,M�39 X��{9 �X�{�b��¢\��.��J��/L�sUl��G!]X����m�ɲޕ�˛����ȤV�kJgi�8�M��
�5���X_�?���Ʌ�G]Y��er���"�[�6�����<���R����������V�-���\��y��i�%u��)��h�,�M�2,R�I�bS�9�\��9�}�����Ƀ�_[�����G��9�g|�aܒ�0���	��i@�4j9���ɬ�V�U͜F�������ћ�Dco?ЪAl�����z��+V��]Դ�~?W�Sɡ�Ӱ�F�A����:1�'U�
.q��rٍ&���k�C��?с��O�B� 7N���Б���d ���E 7uS�$y�����#�?�[�˚ޑU���X�X1�x)��~�!������؉��g���KGv;li��+L�a�2kB���Ƙ���د��	Y�z��c�=����Q[����Y{����К\��������by��,@��, ��\�A�2 �� ��`��?��?`�!����Cķ�qj���g��aa����w,�.��q4ܒ�EH�_��{��������x�PX��N[W�h�i݂��~A���?�w�n�5sTnQ��T�VD�X�J|t��$,6ŶZ(��=4?T�:U�Z۶�^J�������v��	q��d牏ת4�(v�u!N�CY�kbܔ����%��D'�O�Æ_*�n4��RU�t�@�-���c�]E$cL=��'J�Yx� �iV���6�KCz��?m[~���
�4�zu�y=�n�|ِ��|r�S�p\۳c�X^������H�1X�F9zXp{j��6F�����ݝ�L�*N��_�`�n�_xq��;g=���볿��$��_�?ͤ���g��;�MO������S���������mE=�^�5A�)�G�&������q;������g9k�����T���	���v���ĵg���O�ם}�~��~���Bs]s�|()0������������?�V*��槿��}c^���OIT{�r.��3�1�Gq�W�4ͧ����=�/Bw\B�������\�r�0�� ���~��������yx��f�ߙ��=32�ds�9�]`bBO�����6��l��Y4�&n��L�7w�do/8b�������O$����/�Я췇=���������w������<y�{|�/�~}��i���>��'*�
�y~g]�O|���q�N��?�0;���WkI�Z^�׏��͹m��q�#|����В�{ֹ�C<^$��\�qm|��[��;�'���Ŀ��@�>�f�=|��Z�Orw��3������ھ�b��4��ܚ��Y`�_�d��99��}��{/���N�㟟�Ǎ�!�<��x��x�%��Z���&�� ��x���|z��縿uJI�����/��.��v���S��>6��ݪ)�c'wqi�.LE�v�ן����U�LO�N��ҟ���>��'��o��                           .����� � 