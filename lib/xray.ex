defmodule Belfrage.Xray do
  defdelegate new, to: AwsExRay.Trace, as: :new
  
end