defmodule EctoCommons.UUIDValidator do
  @moduledoc ~S"""
  This validator is used to validate UUIDs.

  ## Options
  There are some available `:check` depending on the strictness of what you want to validate:

    - `:uuid1`: Checks to see if the UUID is a v1
    - `:uuid2`: Checks to see if the UUID is a v2
    - `:uuid3`: Checks to see if the UUID is a v3
    - `:uuid4`: Checks to see if the UUID is a v4
    - `:uuid5`: Checks to see if the UUID is a v5
  """

  import Ecto.Changeset

  def validate_uuid(changeset, field, opts \\ []) do
    validate_change(changeset, field, {:uuid, opts}, fn _, value ->
      case UUID.info(value) do
        {:ok, info} ->
          version =
            case Keyword.get(opts, :check, nil) do
              nil -> 0
              :uuid1 -> 1
              :uuid2 -> 2
              :uuid3 -> 3
              :uuid4 -> 4
              :uuid5 -> 5
              _ -> -1
            end

          if 0 == version || version == Keyword.get(info, :version, 0) do
            []
          else
            [{field, {message(opts, "is not valid uuid version"), [validation: :uuid]}}]
          end

        _e ->
          [{field, {message(opts, "is not a valid uuid"), [validation: :uuid]}}]
      end
    end)
  end

  defp message(opts, key \\ :message, default) do
    Keyword.get(opts, key, default)
  end
end
