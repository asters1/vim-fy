package main

import (
	"encoding/json"
	"fmt"
	"net/url"
	"os"
	"strings"
	"sync"
	"time"

	"github.com/asters1/tools"
	"github.com/tidwall/gjson"
)

var text, target_lang, source_lang string
var engines, res []string
var wg sync.WaitGroup
var result string

type Engine struct {
	En         string   `json:"engine"`
	Sl         string   `json:"sl"`
	Tl         string   `json:"tl"`
	Text       string   `json:"text"`
	Phonetic   string   `json:"phonetic"`
	Paraphrase string   `json:"paraphrase"`
	Explains   []string `json:"explains"`
}
type Translate struct {
	Text   string   `json:"text"`
	Status int      `json:"status"`
	Result []Engine `json:"results"`
}

func Fyinit() {

	for i := 1; i < len(os.Args); i++ {
		switch {
		case os.Args[i] == "--target_lang":
			target_lang = os.Args[i+1]
			i = i + 1
		case os.Args[i] == "--source_lang":
			source_lang = os.Args[i+1]
			for i = i + 2; i < len(os.Args); i++ {
				if os.Args[i] == "--engines" {
					// fmt.Println(os.Args[i-1])

					break
				}
				text = text + os.Args[i] + " "
			}
			// text = os.Args[i]
		case os.Args[i] == "--engines":
			for i = i + 1; i < len(os.Args); i++ {
				engines = append(engines, os.Args[i])
			}

		}

	}
}
func GoogleRequest(url string, i int) {
	headers := `"User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36"`

	Text := tools.RequestClient(url, "get", headers, "")
	// fmt.Println(Text)
	Res := gjson.Get(Text, "0.0.0").String()
	res[i] = Res
	// fmt.Println(res)
	wg.Done()

}

// how are you
func GoogleTranslator(engine string, source_lang string, target_lang string, text string) {
	text_list := strings.Split(text, "|||")
	url_list := []string{}
	for i := 0; i < len(text_list); i++ {
		q := url.QueryEscape(strings.TrimSpace(text_list[i]))
		q = strings.Trim(q, "%22")
		// fmt.Println(q)
		url := "http://translate.googleapis.com/translate_a/single?client=gtx&dt=t&sl=" + source_lang + "&tl=" + target_lang + "&q=" + q
		url_list = append(url_list, url)
	}
	res = make([]string, len(url_list))
	for i := 0; i < len(url_list); i++ {
		go GoogleRequest(url_list[i], i)
		wg.Add(1)
	}
	go func() {
		time.Sleep(time.Second * 5)
		fmt.Println("Engine google timed out,please check your network")

		os.Exit(0)
	}()

	wg.Wait()
	eng := &Engine{}
	tran := &Translate{}
	eng.En = "google"
	eng.Sl = "auto"
	eng.Tl = "zh"
	eng.Paraphrase = ""
	eng.Phonetic = ""
	eng.Explains = res

	tran.Status = 1
	tran.Result = append(tran.Result, *eng)
	text_old := strings.Join(text_list, "")
	tran.Text = text_old
	jstrData, err := json.Marshal(tran)
	// _, err := json.Marshal(tran)

	if err != nil {
		os.Exit(0)
	}
	fmt.Println(string(jstrData))

}
func main() {
	Fyinit()
	GoogleTranslator("google", source_lang, target_lang, text)

}
