import oss2

from zhishi3d.utils.OssUtil import auth

# 源和目标 Bucket 名称
bucket_a_name = 'zhishi3d-oss-cn'
bucket_b_name = 'zhishi3d-oss-dev'

bucket_a = oss2.Bucket(auth, 'https://oss-cn-hangzhou.aliyuncs.com', bucket_a_name)
bucket_b = oss2.Bucket(auth, 'https://oss-cn-hangzhou.aliyuncs.com', bucket_b_name)

# 列出 bucket A 的所有对象，并逐个复制
for obj in oss2.ObjectIterator(bucket_a):
    source_key = obj.key
    print(f"Copying: {source_key}")
    # 拷贝对象：指定源 Bucket 和对象路径
    source = f"/{bucket_a_name}/{source_key}"
    bucket_b.copy_object(bucket_a_name, source_key, source_key)

print("✅ 所有对象复制完成。")
