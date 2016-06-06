// JNITest.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"

JNIEXPORT jint JNICALL Java_JNITest_messageBox(JNIEnv *env, jobject jobj, jstring name) {
	jboolean iscopy;
	const char *text;

	text = (*env)->GetStringUTFChars(env, name, &iscopy);
	
	return MessageBoxA(0, text, "Hello from Native Java!", MB_ICONINFORMATION + MB_OKCANCEL);
}