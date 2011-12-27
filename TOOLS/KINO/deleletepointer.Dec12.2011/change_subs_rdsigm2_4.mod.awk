#please set LANG=C before invoking this script to show date in English
#input=  tmp/replace_subs_rdsigm_4
BEGIN{
 str=strftime("%b.%d.%Y")
 comment="ckino " str ": "
}
/^ .*iv_a_oiaxs/{
  old=$0
  if (match($0,"pointer")) { print comment,$0;next;}
  if (match($0,"iv_a_oiaxs *=> *sham%iv_a_oiaxs")) { print comment,$0;next;}
  if (match($0,"sham%iv_a_oiaxs *=> *iv_a_oiaxs")) { print comment,$0;next;}
  if (match($0,"integer,allocatable")) { print comment,$0;next}
  if (match($0,"move_alloc")) { print comment,$0; next}
  gsub("iv_a_oiaxs","sham%iv_a_oiaxs")
  gsub("sham%sham%","sham%")
  if (old != $0 ) {print comment,$0}
}
{print}
