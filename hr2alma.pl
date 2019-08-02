#!/usr/bin/perl
#######################################################
# HR2ALMA.pl
# brute hack to convert old Banner HR -> Voyager SIF output
# to ExLibris "Version 2" XML for import into Alma.
#   
# FACULTY - STAFF version
#
# w. grotophorst 5/2018
#
# (c) 2018, Brute Force Algorithmics
########################################################

sub rtrim($);
sub ltrim($);
sub trim($);

$inputfile = "vgrgmuhr.dat";
$outputfile = "hr.xml";

open(INFILE,$inputfile) or die "Error on input file";
open(OUTFILE,">".$outputfile) or die "Error on open output";


 print OUTFILE "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n";
 print OUTFILE "<users>\n";

my  $sp1 = " ";
my  $sp2 = "  ";
my  $sp4 = "   ";
my  $sp6 = "      ";
my  $sp8 = "        ";
my $sp10 = "          ";
my $sp12 = "            ";


while (<INFILE>) {
 
my $last_name = "";
my $first_name = "";
my $middle_name = "";
my $primaryID = "";
my $job_category = "";
my $usergroup_code = "";
my $usergroup_desc = "";
my $mason_status = "";


my $expire_date = "";
my $purge_date = "";
my $status_date = "";
my $address_line1 = "";
my $address_city = "";
my $address_state = "";
my $address_zip = "";
my $address_country = "";
my $email_address = "";
my $phone_number = "";
my $g_number = "";
my $gender = "";
my $usergroup_code = "";
my $usergroup_desc = "";
my $start_date = "";
my $end_date = "";
my $netID = "";
my $maildomain = "";

$line = $_;


my $IsFaculty = ""; 

$first_name = substr($line,340,20);
$last_name = substr($line,310,30);
$middle_name = substr($line,360,25);

# HR file does not contain addresses or phone numbers
# so much of this code from the SIS conversion program
# is commented out
 
$expire_date = substr($line,188,10);
$purge_date = substr($line,198,10);
$usergroup_code = substr($line,45,7);
$mason_status = uc(substr($line,279,3));
$g_number = substr($line,238,9);

# strip spaces out of usergroup_code
$usergroup_code =~ s/\s+//g;

# convert dots in date to dashes for Alma
$expire_date =~ s/\./\-/g;
$purge_date =~ s/\./\-/g;

$end_date = "";
$netID = substr($line,917,8);
$email_address = rtrim($netID)."\@gmu.edu"; 
 
# sort out the usergroup code and description

if ($usergroup_code eq "polarg") { 
    $IsFaculty = 1;
    $usergroup_desc= "Faculty / Staff"; 
    }
if ($usergroup_code eq "poprtf") { 
    $IsFaculty = 1;
    $usergroup_desc= "Part-Time Faculty"; 
    }
if ($usergroup_code eq "polawf") { 
    $IsFaculty = 1;
    $usergroup_desc= "Law Faculty / Staff"; 
    }
if ($usergroup_code eq "polawp") { 
    $IsFaculty = 1;
    $usergroup_desc= "Law Faculty - Part Time"; 
 }
if ($usergroup_code eq "poireg") { $usergroup_desc= "Wages"; }
# dump the record

print OUTFILE $sp1."<user>\n";
print OUTFILE $sp2."<record_type desc=\"Public\">PUBLIC</record_type>\n";
print OUTFILE $sp2."<primary_id>".rtrim($g_number)."</primary_id>\n";
print OUTFILE $sp2."<first_name>".rtrim($first_name)."</first_name>\n";
print OUTFILE $sp2."<middle_name>".rtrim($middle_name)."</middle_name>\n";
print OUTFILE $sp2."<last_name>".rtrim($last_name)."</last_name>\n";

# fix space between first & last name if there's no middle name

if( length(rtrim($middle_name)) == 0) {
       print OUTFILE $sp2."<full_name>".rtrim($first_name)." ".rtrim($last_name)."</full_name>\n";
 } else {
     print OUTFILE $sp2."<full_name>".rtrim($first_name)." ".rtrim($middle_name)." ".rtrim($last_name)."</full_name>\n";
 }
 
print OUTFILE $sp2."<pin_number/>\n";
print OUTFILE $sp2."<user_title desc=\"\"/>\n";


if ($IsFaculty == 1) {
print OUTFILE $sp2."<job_category desc=\"WRLC Faculty\">WRLCFaculty</job_category>\n";
 } else {
print OUTFILE $sp2."<job_category desc=\"\"></job_category>\n";
}
print OUTFILE $sp2."<job_description/>\n";
print OUTFILE $sp2."<gender desc=\"\"/>\n";
print OUTFILE $sp2."<user_group desc=\"".$usergroup_desc."\">".$usergroup_code."</user_group>\n";
print OUTFILE $sp2."<campus_code desc=\"\"/>\n";
print OUTFILE $sp2."<web_site_url/>\n";
print OUTFILE $sp2."<cataloger_level desc=\"[00] Default Level\">00</cataloger_level>\n";
print OUTFILE $sp2."<preferred_language desc=\"English\">en</preferred_language>\n";
print OUTFILE $sp2."<expiry_date>".rtrim($expire_date)."Z</expiry_date>\n";
print OUTFILE $sp2."<purge_date>".rtrim($purge_date)."Z</purge_date>\n";
print OUTFILE $sp2."<account_type desc=\"External\">EXTERNAL</account_type>\n";
print OUTFILE $sp2."<external_id>HR</external_id>\n";
print OUTFILE $sp2."<password/>\n";
print OUTFILE $sp2."<force_password_change/>\n";
print OUTFILE $sp2."<status desc=\"Active\">ACTIVE</status>\n";

# CONTACT INFO

print OUTFILE $sp2."<contact_info>\n";
#print OUTFILE $sp4."<addresses>\n";
#print OUTFILE $sp6."<address preferred=\"true\" segment_type=\"External\">\n";
#print OUTFILE $sp8."<line1/>\n";
#print OUTFILE $sp8."<city/>\n";
#print OUTFILE $sp8."<state_province/>\n";
#[rint OUTFILE $sp8."<postal_code/>\n";
#print OUTFILE $sp8."<country/>\n";

#print OUTFILE $sp8."<end_date>".rtrim($end_date)."</end_date>\n";
#print OUTFILE $sp10."<address_types>\n";
#print OUTFILE $sp12."<address_type desc=\"Home\">home</address_type>\n";
#print OUTFILE $sp12."<address_type desc=\"Work\">work</address_type>\n";
#print OUTFILE $sp12."<address_type desc=\"School\">school</address_type>\n";
#print OUTFILE $sp12."<address_type desc=\"Alternative\">alternative</address_type>\n";
#print OUTFILE $sp10."</address_types>\n";
#print OUTFILE $sp6."</address>\n";
#print OUTFILE $sp4."</addresses>\n";

print OUTFILE $sp4."<emails>\n";
print OUTFILE $sp6."<email preferred=\"true\" segment_type=\"External\">\n";
print OUTFILE $sp8."<email_address>".rtrim($email_address)."</email_address>\n";
print OUTFILE $sp8."<email_types>\n";
print OUTFILE $sp10."<email_type desc=\"Personal\">personal</email_type>\n";
print OUTFILE $sp10."<email_type desc=\"School\">school</email_type>\n";
print OUTFILE $sp10."<email_type desc=\"Work\">work</email_type>\n";
print OUTFILE $sp8."</email_types>\n";
print OUTFILE $sp6."</email>\n";
print OUTFILE $sp4."</emails>\n";
#print OUTFILE $sp4."<phones>\n";
#print OUTFILE $sp6."<phone preferred=\"true\" preferred_sms=\"false\" segment_type=\"External\">\n";
#print OUTFILE $sp8."<phone_number/>\n";
##print OUTFILE $sp8."<phone_types>\n";
#print OUTFILE $sp10."<phone_type desc=\"Home\">home</phone_type>\n";
#print OUTFILE $sp8."</phone_types>\n";
#print OUTFILE $sp6."</phone>\n";
#print OUTFILE $sp4."</phones>\n";
print OUTFILE $sp2."</contact_info>\n";

###############   IDENTIFIERS

print OUTFILE $sp2."<user_identifiers>\n";
print OUTFILE $sp4."<user_identifier segment_type=\"External\">\n";
print OUTFILE $sp6."<id_type desc=\"University ID\">UNIV_ID</id_type>\n";
print OUTFILE $sp6."<value>".rtrim($netID)."</value>\n";
print OUTFILE $sp6."<status>ACTIVE</status>\n";
print OUTFILE $sp2."</user_identifier>\n";

#print OUTFILE $sp4."<user_identifier segment_type=\"External\">\n";
#print OUTFILE $sp6."<id_type desc=\"Institution ID\">INST_ID</id_type>\n";
#print OUTFILE $sp6."<value>".rtrim($g_number)."</value>\n";
#print OUTFILE $sp6."<status>INACTIVE</status>\n";
#print OUTFILE $sp4."</user_identifier>\n";

print OUTFILE $sp2."</user_identifiers>\n";

print OUTFILE $sp2."<user_roles>\n";
print OUTFILE $sp4."<user_role>\n";
print OUTFILE $sp6."<status>ACTIVE</status>\n";
print OUTFILE $sp6."<scope desc=\"George Mason University Libraries\">01WRLC_GML</scope>\n";
print OUTFILE $sp6."<role_type>200</role_type>\n";
print OUTFILE $sp4."</user_role>\n";
print OUTFILE $sp2."</user_roles>\n";

print OUTFILE $sp2."<user_statistics>\n";
print OUTFILE $sp4."<user_statistic segment_type=\"External\">\n";

print OUTFILE $sp6."<statistic_category>".rtrim($mason_status)."</statistic_category>\n";
 
print OUTFILE $sp4."</user_statistic>\n";
print OUTFILE $sp2."</user_statistics>\n";
 
print OUTFILE $sp1."</user>\n";

}

# print the closing </users> to the output file since this will be the
# end of the combined SIS and HR file created by the shell script that
# launches this program after the sis2alma script has run.

print OUTFILE "</users>\n";

close(INFILE);

close(OUTFILE);

#
# subroutines
#

# remove whitespace from the start and end of the string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
# remove leading whitespace
sub ltrim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	return $string;
}
# remove trailing whitespace
sub rtrim($)
{
	my $string = shift;
	$string =~ s/\s+$//;
	return $string;
}
