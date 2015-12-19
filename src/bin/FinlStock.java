
package bin;




import java.io.IOException;
import java.math.BigDecimal;
import java.util.Calendar;

import yahoofinance.Stock;
import yahoofinance.YahooFinance;
import yahoofinance.quotes.fx.FxQuote;
import yahoofinance.quotes.fx.FxSymbols;
import yahoofinance.quotes.stock.StockDividend;
import yahoofinance.quotes.stock.StockQuote;
import yahoofinance.quotes.stock.StockStats;

public class FinlStock {

	public static void main(String[] args) {
		try {
			FinlStock stock2 = new FinlStock("AAPL");

			BigDecimal ask = stock2.finlQuote.ask;
			System.out.println(ask);
		} catch (NullTickerException NTE) {
			NTE.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public String symbol;
	public FinlQuote finlQuote;
	public FinlFundamentals finlFundamentals;
	public FinlDividend finlDividend;

	////////////////////////////////////////////
	//////////*FinlStock Constructor*///////////
	///////////Gets all sub-objects/////////////
	public FinlStock(String ticker) throws NullTickerException, IOException {

		/* Check for null ticker */
		if(ticker == null || ticker.equals(null)) {
			throw new NullTickerException();
		}

		this.symbol 					= ticker;
		yahoofinance.Stock testStock 	= YahooFinance.get(symbol);

		this.finlQuote 					= new FinlStock.FinlQuote(testStock);
		this.finlFundamentals 			= new FinlStock.FinlFundamentals(testStock);
		this.finlDividend 				= new FinlStock.FinlDividend(testStock);
	}

	public FinlStock() throws NullTickerException {
			throw new NullTickerException();
	}



	public class FinlFundamentals {

		/*Fundamentals Object*/
		private StockStats fundamentals;

		/*Fundamentals*/
		public BigDecimal 	bookValuePerShare;
		public BigDecimal 	ebitda;
		public BigDecimal	eps;
		public BigDecimal	marketCap;
		public BigDecimal	pe;
		public BigDecimal	peg;
		public BigDecimal	priceBook;
		public BigDecimal	priceSales;
		public BigDecimal	revenue;
		public BigDecimal	roe;
		public long			sharesFloat;
		public long			sharesOutstanding;

		/*Estimates*/
		public BigDecimal	epsEstimateCurrentYear;
		public BigDecimal	epsEstimateNextQuarter;
		public BigDecimal	epsEstimateNextYear;
		public BigDecimal	oneYearTargetPrice;

		////////////////////////////////////////////
		//////////////*Constructors*////////////////
		////////////////////////////////////////////
		public FinlFundamentals(String symbol) throws IOException {
			yahoofinance.Stock stock = YahooFinance.get(symbol);
			fundamentals = stock.getStats();
			this.populateStatistics();
			this.populateEstimates();
		}	//end constructor FinlQuote(String symbol)

		public FinlFundamentals(yahoofinance.Stock stock) {
			fundamentals = stock.getStats();
			this.populateStatistics();
			this.populateEstimates();
		}	//end constructor FinlQuote(String symbol)

		private void populateStatistics() {
			bookValuePerShare 	= this.fundamentals.getBookValuePerShare();
			ebitda 				= this.fundamentals.getEBITDA();
			eps 				= this.fundamentals.getEps();
			marketCap 			= this.fundamentals.getMarketCap();
			pe 					= this.fundamentals.getPe();
			peg 				= this.fundamentals.getPeg();
			priceBook 			= this.fundamentals.getPriceBook();
			priceSales 			= this.fundamentals.getPriceSales();
			revenue 			= this.fundamentals.getRevenue();
			roe 				= this.fundamentals.getROE();
			sharesFloat 		= this.fundamentals.getSharesFloat();
			sharesOutstanding 	= this.fundamentals.getSharesOutstanding();
		}	//end populateStatistics()

		private void populateEstimates() {
			epsEstimateCurrentYear 	= this.fundamentals.getEpsEstimateCurrentYear();
			epsEstimateNextQuarter 	= this.fundamentals.getEpsEstimateNextQuarter();
			epsEstimateNextYear		= this.fundamentals.getEpsEstimateNextYear();
			oneYearTargetPrice		= this.fundamentals.getOneYearTargetPrice();
		}	//end populateEstimates()
	}

	////////////////////////////////////////////
	////////////*Quotes SubClass*/////////////
	////////////////////////////////////////////
	public class FinlQuote {

		/*Quote & Prices*/
		private StockQuote 	quote;
		/*////Prices////*/
		public BigDecimal 	price;
		public BigDecimal 	priceOpen;
		public BigDecimal 	pricePrevClose;
		public BigDecimal	priceMA200;
		public BigDecimal	priceMA50;
		public BigDecimal	priceDayHigh;
		public BigDecimal	priceDayLow;
		public BigDecimal	bid;
		public BigDecimal 	ask;
		public long	 		avgVolume;
		/*Price Movement*/
		public BigDecimal	change;			//change from current price to previous close
		public BigDecimal	changePercent;	//change from current price to previous close, in percent
		public BigDecimal	changeFromMA200;
		public BigDecimal	changeFromMA50;
		public BigDecimal	changeFromYearHigh;
		public BigDecimal	changeFromYearLow;


		////////////////////////////////////////////
		//////////////*Constructors*////////////////
		////////////////////////////////////////////
		public FinlQuote(String symbol) throws IOException {
			yahoofinance.Stock stock = YahooFinance.get(symbol);
			quote = stock.getQuote();
			this.populatePrice();
			this.populateMovement();
		}	//end constructor FinlQuote(String symbol)

		public FinlQuote(yahoofinance.Stock stock) {
			quote = stock.getQuote();
			this.populatePrice();
			this.populateMovement();
		}	//end constructor FinlQuote(String symbol)

		////////////////////////////////////////////
		/////////////*Populate Methods*/////////////
		////////////////////////////////////////////
		private void populatePrice() {
			price 				= this.quote.getPrice();
			priceOpen 			= this.quote.getOpen();
			pricePrevClose 		= this.quote.getPreviousClose();
			priceMA200 			= this.quote.getPriceAvg200();
			priceMA50 			= this.quote.getPriceAvg50();
			priceDayHigh 		= this.quote.getDayHigh();
			priceDayLow 		= this.quote.getDayLow();
			bid 				= this.quote.getBid();
			ask 				= this.quote.getAsk();
			avgVolume 			= this.quote.getAvgVolume();
		}	//end populatePrice()

		private void populateMovement() {
			change 				= this.quote.getChange();
			changePercent 		= this.quote.getChangeInPercent();
			changeFromMA200 	= this.quote.getChangeFromAvg200();
			changeFromMA50 		= this.quote.getChangeFromAvg50();
			changeFromYearHigh 	= this.quote.getChangeFromYearHigh();
			changeFromYearLow 	= this.quote.getChangeFromYearLow();
		}	//end populateMovement()
	}	//end FinlQuote subclass

	////////////////////////////////////////////
	////////////*Dividend SubClass*/////////////
	////////////////////////////////////////////
	public class FinlDividend {

		/*Dividend Object*/
		private StockDividend dividend;

		/*Dividend Data*/
		public BigDecimal 	annualYield;
		public BigDecimal 	annualYieldPercent;
		public Calendar	exDivDate;
		public Calendar	payDate;
		public String 		exDivDate_String;
		public String 		payDate_String;

		/*Pass a Stock Object*/
		public FinlDividend(yahoofinance.Stock stock) {
			dividend 				= stock.getDividend();

			annualYield 			= this.dividend.getAnnualYield();
			annualYieldPercent 		= this.dividend.getAnnualYieldPercent();
			exDivDate 				= this.dividend.getExDate();
			payDate 				= this.dividend.getPayDate();
			exDivDate_String 		= this.exDivDate.toString();
			payDate_String 			= this.payDate.toString();
		}	//end constructor FinlDividend(Stock stock)

		/*Pass a Stock Symbol*/
		public FinlDividend(String symbol) throws IOException {
			yahoofinance.Stock stock = YahooFinance.get(symbol);
			dividend 				= stock.getDividend();

			annualYield 			= this.dividend.getAnnualYield();
			annualYieldPercent 		= this.dividend.getAnnualYieldPercent();
			exDivDate 				= this.dividend.getExDate();
			payDate 				= this.dividend.getPayDate();
			exDivDate_String 		= this.exDivDate.toString();
			payDate_String 			= this.payDate.toString();
		}	//end constructor FinlDividend(String symbol)
	} 	//end FinlDividend subclass
}
