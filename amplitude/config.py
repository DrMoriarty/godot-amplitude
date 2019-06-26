def can_build(env, platform):
	if platform == "android":
		return True
	if platform == "iphone":
		return True
	return False

def configure(env):
	if (env['platform'] == 'android'):
		env.android_add_java_dir("android/src")
		#env.android_add_dependency("compile fileTree(dir: '../../../modules/amplitude/android/libs', include: '*.jar')")
		env.android_add_dependency("implementation 'com.amplitude:android-sdk:2.16.0'")
		env.android_add_to_permissions("android/AndroidManifestPermissionsChunk.xml")
	if (env['platform'] == 'iphone'):
		pass

