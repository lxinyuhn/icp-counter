import Text "mo:base/Text";
import Int "mo:base/Int";

// Create a simple Counter actor.
actor Counter {
  stable var currentValue : Nat = 0;

  public type HeaderField = (Text, Text);
  public type HttpRequest = {
      url: Text;
      method: Text;
      body: [Nat8];
      headers: [HeaderField];
  };

  public type HttpResponse = {
      body: Blob;
      headers: [HeaderField];
      streaming_strategy: ?StreamingStrategy;
      status_code: Nat16;
  };

  public type Key = Text;
  public type Path = Text;
  public type chunkId = Nat;
  public type SetAssetContentArguments = {
      key: Key;
      sha256: ?[Nat8];
      chunk_ids: [chunkId];
      content_encoding: Text;
  };
  public type StreamCallbackHttpResponse = {
      token: ?StreamCallbackToken;
      body: [Nat8];
  };
  public type StreamCallbackToken = {
      key: Key;
      sha256: ?[Nat8];
      index: Nat;
      content_encoding: Text;
  };
  public type StreamingStrategy = {
      #Callback: {
          token: StreamCallbackToken;
          callback: shared query StreamCallbackToken -> async StreamCallbackHttpResponse;
      };
  };

  public shared query func http_request(request: HttpRequest): async HttpResponse{
      {
          body = Text.encodeUtf8("<html><body><h1>My Counter</h1><h2>currentValue:"# Int.toText(currentValue) #"</h2></body></html>");
          headers = [("Content-Type", "text/html; charset=utf-8")];
          streaming_strategy = null;
          status_code = 200;
      }
  };

  // Increment the counter with the increment function.
  public func increment() : async () {
    currentValue += 1;
  };

  // Read the counter value with a get function.
  public query func get() : async Nat {
    currentValue
  };

  // Write an arbitrary value with a set function.
  public func set(n: Nat) : async () {
    currentValue := n;
  };


}