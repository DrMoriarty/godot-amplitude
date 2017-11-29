def can_build(plat):
	return plat=="android"

def configure(env):
	if (env['platform'] == 'android'):
		env.android_add_java_dir("android/src")
		env.android_add_dependency("compile fileTree(dir: '../../../modules/amplitude/android/libs', include: '*.jar')")
		env.android_add_dependency("compile 'com.amplitude:android-sdk:2.+'")
		env.android_add_to_permissions("android/AndroidManifestPermissionsChunk.xml")

