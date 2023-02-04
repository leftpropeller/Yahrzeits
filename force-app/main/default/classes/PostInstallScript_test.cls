// Steve Berley - steve@leftpropeller.com
//
@isTest
private class PostInstallScript_test {
    private static void test(){
        PostInstallScript postinstall = new PostInstallScript(); 
        Test.testInstall(postinstall, new Version(1,0), true);
    }
}