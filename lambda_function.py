import json
import boto3
import os

s3 = boto3.client('s3')
translate = boto3.client('translate')
response_bucket = os.environ.get('RESPONSE_BUCKET')

def lambda_handler(event, context):
    # Extract bucket & key info from trigger
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    # Download and process input json
    obj = s3.get_object(Bucket=bucket, Key=key)
    data = json.loads(obj['Body'].read().decode('utf-8'))
    
    source_lang = data.get('source_lang')
    target_lang = data.get('target_lang')
    texts      = data.get('texts', [])
    translated = []
    for line in texts:
        result = translate.translate_text(
            Text=line,
            SourceLanguageCode=source_lang,
            TargetLanguageCode=target_lang
        )
        translated.append(result['TranslatedText'])
    # Prepare output JSON
    out_json = {
        "input_language": source_lang,
        "output_language": target_lang,
        "original": texts,
        "translated": translated
    }
    # Write result to response bucket
    out_key = key.replace('requests/', '').replace('.json', '_translated.json')
    s3.put_object(
        Bucket=response_bucket,
        Key=f"responses/{out_key}",
        Body=json.dumps(out_json).encode('utf-8')
    )
    return {"status": "done", "output": out_key}