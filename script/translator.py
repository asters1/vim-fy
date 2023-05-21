# -*- coding: utf-8 -*-
import re
import json
import argparse
import requests
from urllib.parse import quote_plus as url_quote
from multiprocessing.dummy import Pool
#


def GoogleRequest(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36"
    }
    res = requests.get(url, headers).text
    jres = json.loads(res)
    return jres[0][0][0]


def GoogleTranslator(engine, source_lang, target_lang, text):
    text_list = text.split("|||", -1)

    url_list = []
    for text in text_list:
        text = text.strip()
        q = url_quote(text)

        url = "http://translate.googleapis.com/translate_a/single?client=gtx&dt=t&sl=" + \
            source_lang+"&tl="+target_lang+"&q="+q
        url_list.append(url)
#    result = jres[0][0][0]
    result = {}
    result["engine"] = engine
    result["sl"] = source_lang
    result["tl"] = target_lang
    result["text"] = text
    result["phonetic"] = ""
    result["paraphrase"] = ""
    pool = Pool(len(url_list))
    res_list = pool.map(GoogleRequest, url_list)
    result["explains"] = res_list
# update gradle and dependency version
# Small misc string translation
# update gradle and dependency version
# Small misc string translation
    return result


def sanitize_input_text(text):
    while True:
        try:
            text.encode()
            break
        except UnicodeEncodeError:
            text = text[:-1]
    return text


def cut(obj, sec):
    return [obj[i:i+sec] for i in range(0, len(obj), sec)]


def main():

    parser = argparse.ArgumentParser()
    parser.add_argument("--engines", nargs="+",
                        required=False, default=["google"])
    parser.add_argument("--target_lang", required=False, default="zh")
    parser.add_argument("--source_lang", required=False, default="en")
    parser.add_argument("--proxy", required=False)
    parser.add_argument("--options", type=str, default=None, required=False)
    parser.add_argument("text", nargs="+", type=str)
    args = parser.parse_args()

    args.text = [sanitize_input_text(x) for x in args.text]

    text = " ".join(args.text).strip("'").strip('"').strip()
    text = re.sub(r"([a-z])([A-Z][a-z])", r"\1 \2", text)
    text = re.sub(r"([a-zA-Z])_([a-zA-Z])", r"\1 \2", text).lower()
    text = text.strip()
    engines = args.engines
    to_lang = args.target_lang
    from_lang = args.source_lang
    if args.options:
        options = args.options.split(",")
    else:
        options = []

    translation = {}
    translation["text"] = text
    translation["status"] = 1
    translation["results"] = []
    for e in engines:
        if e == "google":
            res = GoogleTranslator(e, from_lang, to_lang, text)
            translation["results"].append(res)

    print(json.dumps(translation))


if __name__ == "__main__":
    main()
