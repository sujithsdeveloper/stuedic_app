# Keep all ML Kit classes
-keep class com.google.mlkit.** { *; }
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
-keep class com.google.mlkit.vision.text.chinese.** { *; }

-keep class com.arthenica.** { *; }

-keep class **.zego.** { *; }

-dontwarn com.itgsa.opensdk.mediaunit.KaraokeMediaHelper
-dontwarn java.beans.ConstructorProperties
-dontwarn java.beans.Transient
-dontwarn org.w3c.dom.bootstrap.DOMImplementationRegistry