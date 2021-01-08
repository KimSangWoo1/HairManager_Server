package login;

import java.nio.ByteBuffer;
import java.security.AlgorithmParameters;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

/*
 *  Crypto ( ��ȣȭ )
 *  1 - aesKeyGen ( AES ��ĪŰ ���� [����] )
 *  2 - encryptAES256 ( AES256 ��ȣȭ )
 *  3 - decryptAES256 ( AES256 ��ȣȭ )
 */
public class Crypto {

	public static String secretKEY = "";

	// 1 - aesKeyGen ( AES ��ĪŰ ���� [����] )
	public static void aesKeyGen() throws NoSuchAlgorithmException {

		KeyGenerator generator = KeyGenerator.getInstance("AES"); // Ű������ ����� ��ȣ �˰�����
		SecureRandom secureRandom = new SecureRandom(); // ������ ���� ���� 'math random'���� ���� ������ ����
		generator.init(256, secureRandom); // ����� Ű ���� �� ������ �̿��Ͽ� Ű �ʱ�ȭ
		Key secureKey = generator.generateKey();

		// �������������� Base64.encodeBase64String NotMethod �̽��߻�
		// ��ĪŰ ��ü�� 'String'���� ��ȯ

		secretKEY = Base64.getEncoder().encodeToString(secureKey.getEncoded());

		/** �̷��� String ���·� ������������ ��Ʈ�p ���� ��, ��ü��ȯ/���ڵ��� ���ŷο��� ������ �Ͱ����ϴ�. **/
	}

	// 2 - encryptAES256 ( AES256 ��ȣȭ )
	public static String EncryptAES256(String msg) throws Exception {

		String key = secretKEY;
		SecureRandom random = new SecureRandom();
		byte bytes[] = new byte[20];
		random.nextBytes(bytes);
		byte[] saltBytes = bytes;

		// Password-Based Key Derivation function 2
		SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
		// 70000�� �ؽ��Ͽ� 256 bit ������ Ű�� �����.
		PBEKeySpec spec = new PBEKeySpec(key.toCharArray(), saltBytes, 70000, 256);

		SecretKey secretKey = factory.generateSecret(spec);
		SecretKeySpec secret = new SecretKeySpec(secretKey.getEncoded(), "AES");

		// �˰�����/���/�е�
		// CBC : Cipher Block Chaining Mode
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");

		cipher.init(Cipher.ENCRYPT_MODE, secret);

		AlgorithmParameters params = cipher.getParameters();

		// Initial Vector(1�ܰ� ��ȣȭ ���Ͽ�)

		byte[] ivBytes = params.getParameterSpec(IvParameterSpec.class).getIV();
		byte[] encryptedTextBytes = cipher.doFinal(msg.getBytes("UTF-8"));
		byte[] buffer = new byte[saltBytes.length + ivBytes.length + encryptedTextBytes.length];

		System.arraycopy(saltBytes, 0, buffer, 0, saltBytes.length);
		System.arraycopy(ivBytes, 0, buffer, saltBytes.length, ivBytes.length);
		System.arraycopy(encryptedTextBytes, 0, buffer, saltBytes.length + ivBytes.length, encryptedTextBytes.length);

		return Base64.getEncoder().encodeToString(buffer);
	}

	// 3 - decryptAES256 ( AES256 ��ȣȭ )
	public static String DecryptAES256(String msg) throws Exception {

		String key = secretKEY;
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		ByteBuffer buffer = ByteBuffer.wrap(Base64.getDecoder().decode(msg));

		byte[] saltBytes = new byte[20];
		buffer.get(saltBytes, 0, saltBytes.length);
		byte[] ivBytes = new byte[cipher.getBlockSize()];
		buffer.get(ivBytes, 0, ivBytes.length);
		byte[] encryoptedTextBytes = new byte[buffer.capacity() - saltBytes.length - ivBytes.length];
		buffer.get(encryoptedTextBytes);

		SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
		PBEKeySpec spec = new PBEKeySpec(key.toCharArray(), saltBytes, 70000, 256);

		SecretKey secretKey = factory.generateSecret(spec);
		SecretKeySpec secret = new SecretKeySpec(secretKey.getEncoded(), "AES");

		cipher.init(Cipher.DECRYPT_MODE, secret, new IvParameterSpec(ivBytes));

		byte[] decryptedTextBytes = cipher.doFinal(encryoptedTextBytes);

		return new String(decryptedTextBytes);
	}
}